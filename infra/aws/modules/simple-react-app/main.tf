locals {
  app_id    = "sra"
  app_name  = "simple-react-app"
  name      = "${var.namespace}-${var.environment}-${local.app_id}"
  subdomain = "${var.environment}-${local.app_id}"
}

################################################################################
# S3 bucket for static website hosting
################################################################################
// Create an S3 bucket with tags configuration
resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.name
}

// Enable bucket versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

// Set the bucket encryption is SSE-S3
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// Create an S3 bucket policy to allow CloudFront to access the bucket
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  depends_on = [aws_s3_bucket.s3_bucket, aws_cloudfront_distribution.s3_distribution]
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.s3_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
}
EOF
}

// Create a CORS configuration
resource "aws_s3_bucket_cors_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://${local.subdomain}.${var.zone_name}"]
    max_age_seconds = 3000
  }
}

################################################################################
# CloudFront distribution
################################################################################
data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "managed_cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  depends_on                        = [aws_s3_bucket.s3_bucket]
  name                              = aws_s3_bucket.s3_bucket.id
  description                       = "Origin Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [aws_s3_bucket.s3_bucket]

  aliases = ["${local.subdomain}.${var.zone_name}"]

  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = aws_s3_bucket.s3_bucket.id
  }

  enabled             = true
  comment             = "CDN for ${local.name}"
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.s3_bucket.id

    cache_policy_id          = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_cors_s3_origin.id

    viewer_protocol_policy = "https-only"
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  #   ordered_cache_behavior {
  #     path_pattern     = "/static/*"
  #     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #     cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #     target_origin_id = "s3-${local.name}"

  #     forwarded_values {
  #       query_string = false

  #       cookies {
  #         forward = "none"
  #       }
  #     }

  #     viewer_protocol_policy = "redirect-to-https"
  #     min_ttl                = 0
  #     default_ttl            = 3600
  #     max_ttl                = 86400
  #   }

  #   restrictions {
  #     geo_restriction {
  #       restriction_type = "none"
  #     }
  #   }

  viewer_certificate {
    # cloudfront_default_certificate = true
    # minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method  = "sni-only"
    acm_certificate_arn = module.acm.acm_certificate_arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

################################################################################
# Route53 records for CloudFront distribution
################################################################################
data "aws_route53_zone" "this" {
  name = var.zone_name
}

# CloudFront supports US East (N. Virginia) Region only.
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = aws_cloudfront_distribution.s3_distribution.domain_name
        zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
      }
    },
  ]
}

################################################################################
# ACM certificate for CloudFront distribution
################################################################################
module "acm" {
  # depends_on = [module.records]
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = var.zone_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${var.zone_name}"]

  wait_for_validation = true

  providers = {
    aws = aws.us-east-1
  }
}
