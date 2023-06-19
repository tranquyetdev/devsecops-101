output "domain_name" {
  value = module.s3_static_website_cf.cloudfront_custom_domain_name
}
