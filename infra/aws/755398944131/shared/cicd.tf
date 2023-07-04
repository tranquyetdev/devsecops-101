
# Minimum permissions required for Github Actions to deploy to S3 and invalidate CloudFront
resource "aws_iam_policy" "s3_deploy" {
  path        = "/"
  description = "IAM policy for deploying to S3 and invalidating CloudFront"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : ["s3:PutObject", "s3:PutObjectAcl"],
        "Effect" : "Allow",
        "Resource" : ["arn:aws:s3:::acp-preview-sra/*"],
        "Sid" : "AllowUploadToS3Bucket"
      },
      {
        "Action" : ["cloudfront:CreateInvalidation"],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:cloudfront::${var.aws_account_id}:distribution/EWWWBSSQ5HDOX"
        ],
        "Sid" : "CloudFrontInvalidation"
      }
    ]
  })
}

# Minimum permissions required for Github Actions to deploy to ECS
resource "aws_iam_policy" "ecs_deploy" {
  path        = "/"
  description = "IAM policy for deploying to ECS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "ECRPushAccess",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource" : "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${local.sna_repo_name}"
      },
      {
        "Sid" : "ECSRunTask",
        "Effect" : "Allow",
        "Action" : ["ecs:RunTask", "ecs:DescribeTasks"],
        "Resource" : "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task/*",
        "Condition" : {
          "ArnLike" : {
            "ecs:cluster" : "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:cluster/${var.namespace}-*-cluster"
          }
        }
      },
      {
        "Sid" : "ECSTaskDefinition",
        "Effect" : "Allow",
        "Action" : "ecs:RegisterTaskDefinition",
        "Resource" : "*"
      },
      {
        "Sid" : "PassRolesInTaskDefinition",
        "Effect" : "Allow",
        "Action" : ["iam:PassRole"],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole",
          "arn:aws:iam::${var.aws_account_id}:role/acp-*-sna-service-*"
        ]
      },
      {
        "Sid" : "DeployService",
        "Effect" : "Allow",
        "Action" : ["ecs:UpdateService", "ecs:DescribeServices"],
        "Resource" : [
          "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:service/${var.namespace}-*-cluster/${var.namespace}-*-sna-service",
        ]
      }
    ]
  })
}

# Use the off-the-shelves module
# https://registry.terraform.io/modules/unfunco/oidc-github/aws/latest
module "oidc_github" {
  source  = "unfunco/oidc-github/aws"
  version = "1.5.0"

  github_repositories = [
    "tranquyetdev/aws-cloud-practice",
    "tranquyetdev/aws-cloud-practice:ref:refs/heads/main",
  ]

  #  Configure IAM role that will be assumed by Github Actions
  iam_role_name = "${var.namespace}-${var.app_id}-cicd-role"
  iam_role_policy_arns = [
    aws_iam_policy.s3_deploy.arn,
    aws_iam_policy.ecs_deploy.arn,
  ]
  max_session_duration = 3600

  tags = {
    Description = "Managed by Terraform"
  }
}
