# S3 Static Website + Cloudfront + WAF

## Requirements

- Region: ap-southeast-1
- Cloudfront

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

- WAF: Enabled

  - Common rules (TBD)

- Route53

  - Alias record point to cloudfront distribution url

- S3 bucket:

  - Private
  - Versioning: Enabled
  - MFA Delete: Disabled
  - Encryption: SSE-KMS (aws/s3)
  - Access log: Disabled
  - Bucket policy:

    - Enforce SSL in transit

  - CORS: Enabled
  - Lifecycle rules
    - `DeleteIncompleteUploads`: Delete after 7 days
    - `DeleteOldVersions`: All other noncurrent versions are permanently deleted after 30 days
    - `MoveToStandardIA`: Objects move to Standard-IA after 30 days
  - Tags
    - environment: sandbox
    - managedBy: terraform
