# SIMPLE-REACT-APP INFRA

## Requirements

- [Large-size](https://github.com/antonbabenko/terraform-best-practices/tree/master/examples/large-terraform) / [Medium-size](https://github.com/antonbabenko/terraform-best-practices/tree/master/examples/medium-terraform) Infrastructure
- Region: ap-southeast-1
- CloudFront

  - S3 origin
  - Price class: PriceClass_200 (North America, Europe, Asia, Middle East, and Africa)
  - Compress objects: Yes
  - Origin access control (OCA)
  - Viewer
    - HTTPS only
    - Allowed methods: GET, HEAD, OPTIONS
    - Restrict viewer access: No
  - Cache policy and origin request policy:

    - Cache policy: Managed-CachingOptimized
    - Request policy: Managed-CORS-S3Origin

  - Enable Origin Shield: No

  - Custom doman: Yes
  - SSL certificate: ACM

- Route53

  - Alias record point to cloudfront distribution url

- S3 bucket:

  - Private
  - Versioning: Enabled
  - MFA Delete: Disabled
  - Encryption: SSE-S3
  - Access log: Disabled
  - Bucket policy:

    - Enforce SSL in transit

  - CORS: Enabled
  - Lifecycle rules
    - `DeleteIncompleteUploads`: Delete after 7 days
    - `DeleteOldVersions`: All other noncurrent versions are permanently deleted after 30 days
    - `MoveToStandardIA`: Objects move to Standard-IA after 30 days

## Upcoming

- S3 Encryption: SSE-KMS (aws/s3)
- Add new Cache Behaviors
- Add new Origin Request Polices
- Enable and configure WAF
