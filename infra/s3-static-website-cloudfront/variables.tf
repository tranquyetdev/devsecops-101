variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "quyettran-s3-static-website-cloudfront"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "sandbox"
}

variable "zone_name" {
  description = "Zone name"
  type        = string
  default     = "sandbox.quyettran.com"
}
