
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }
  backend "s3" {
    bucket = "quyettran-terraform-state-demo"
    key    = "labs/s3-static-website/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

# Keep it simple by using locals to define the region and bucket name
locals {
  region      = "ap-southeast-1"
  bucket_name = "quyettran-s3-static-website"
}

provider "aws" {
  region = local.region
}

// Create a simple bucket with tags configuration
resource "aws_s3_bucket" "s3-static-website" {
  bucket        = local.bucket_name
  force_destroy = true

  tags = {
    Name        = "quyettran-s3-static-website"
    Environment = "dev"
  }
}

// Enable bucket versioning
resource "aws_s3_bucket_versioning" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  versioning_configuration {
    mfa_delete = "Disabled"
    status     = "Enabled"
  }
}

// Create a bucket policy to allow public access to the bucket
resource "aws_s3_bucket_policy" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  // Use jsonencode to create a policy document to allow public access to the bucket 
  // and enforce SSL in transit
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      #   {
      #     Sid       = "DenyNoneSSLRequests"
      #     Effect    = "Deny"
      #     Principal = "*"
      #     Action    = "s3:*"
      #     Resource = [
      #       "arn:aws:s3:::${local.bucket_name}/*",
      #     ]
      #     Condition = {
      #       Bool = {
      #         "aws:SecureTransport" : "false"
      #       }
      #     }
      #   },
      {
        Sid       = "MakeEntireBucketPublic",
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::${local.bucket_name}/*",
        ]
      }
    ]
  })
}

// Create a bucket website configuration
resource "aws_s3_bucket_website_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  #   routing_rule {
  #     condition {
  #       http_error_code_returned_equals = "404"
  #     }
  #     redirect {
  #       protocol                = "https"
  #       host                    = "quyettran-s3-static-website.s3-website-ap-southeast-1.amazonaws.com"
  #       replace_key_prefix_with = "#!/error.html"
  #     }
  #   }
}

// Create a bucket acl configuration
resource "aws_s3_bucket_public_access_block" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// Create a CORS configuration
resource "aws_s3_bucket_cors_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://${local.bucket_name}.s3-website-ap-southeast-1.amazonaws.com"]
    max_age_seconds = 3000
  }
}

// Create bucket encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// Create lifecycle policies
resource "aws_s3_bucket_lifecycle_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-website.id

  // Remove old versions of objects after 30 days
  rule {
    id     = "DeleteOldVersions"
    status = "Enabled"
    filter {
      prefix = ""
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  // Delete incomplete multipart uploads after 7 days
  rule {
    id     = "DeleteIncompleteUploads"
    status = "Enabled"
    filter {
      prefix = ""
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  // Transition objects to Standard-IA after 30 days (for cost savings, demo purposes only)
  rule {
    id     = "MoveToStandardIA"
    status = "Enabled"
    filter {
      prefix = ""
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}


output "website_endpoint" {
  value = "http://${local.bucket_name}.${aws_s3_bucket_website_configuration.s3-static-website.website_domain}"
}
