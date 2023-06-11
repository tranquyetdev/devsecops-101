# S3 Static Website

- A very basic static website that is hosted on a S3 bucket for demo purposes
- Once finish testing, `terraform destroy` to clean up quickly

## Requirements

- Static website hosting enabled
- Bucket versioning enabled
- Bucket MFA deleted disabled
- Bucket encryption enabled: SSE-S3
- Lifecyle policies added
- No Cloudfront integration
