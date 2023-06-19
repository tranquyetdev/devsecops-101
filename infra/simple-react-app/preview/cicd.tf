
resource "aws_iam_policy" "cicd" {
  path        = "/"
  description = "IAM policy for CI/CD role"

  # Minimum permissions required for Github Actions to deploy to S3 and invalidate CloudFront
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowUploadToS3Bucket"
        Action = ["s3:PutObject", "s3:PutObjectAcl"]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.vertical}-*-${var.app_id}/*",
        ]
      },
      {
        "Sid" : "CloudFrontInvalidation",
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:CreateInvalidation"
        ],
        "Resource" : [
          "arn:aws:cloudfront::${var.aws_account_id}:distribution/${module.s3_static_website_cf.distribution_id}"
        ]
      }
    ]
  })
}

# Use the off-the-shelves module
# https://registry.terraform.io/modules/unfunco/oidc-github/aws/latest
module "oidc_github" {
  # As this is a single resouce instance per AWS account
  # So for the sake of this demo, we will the preview environment to create the provider
  count = var.environment == "preview" ? 1 : 0

  source  = "unfunco/oidc-github/aws"
  version = "1.5.0"

  github_repositories = [
    "tranquyetdev/aws-cloud-practice",
    "tranquyetdev/aws-cloud-practice:ref:refs/heads/main",
  ]

  #  Configure IAM role that will be assumed by Github Actions
  iam_role_name = "${var.vertical}-${var.environment}-cf-cicd-role"
  iam_role_policy_arns = [
    aws_iam_policy.cicd.arn,
  ]
  max_session_duration = 7200

  tags = {
    Description = "Managed by Terraform"
  }
}
