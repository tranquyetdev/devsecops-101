
output "cloudfront_domain_name" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "cloudfront_custom_domain_name" {
  value = "https://${local.subdomain}.${var.zone_name}"
}

output "distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
