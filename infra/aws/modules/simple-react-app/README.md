# infra / simple-react-app

## Demo

## Specs

- CloudFront

  - S3 origin
  - Origin access control (OCA)
  - Viewer
    - HTTPS only
    - Allowed methods: GET, HEAD, OPTIONS
    - Restrict viewer access: No
  - Cache policy and origin request policy:

    - Cache policy: Managed-CachingOptimized
    - Request policy: Managed-CORS-S3Origin

  - Custom doman: Yes
  - SSL certificate: ACM

- S3 origin:

  - Private bucket
  - Versioning: Enabled
  - MFA Delete: Disabled
  - Encryption: SSE-S3
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
