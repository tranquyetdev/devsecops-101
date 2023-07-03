# Create ECR repository for simple-nextjs-app

locals {
  sna_name      = "simple-nextjs-app"
  sna_repo_name = "${var.namespace}/${local.sna_name}"
}

resource "aws_ecr_repository" "ecr_sna_repo" {
  name                 = local.sna_repo_name
  image_tag_mutability = "IMMUTABLE"
  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}

output "ecr_sna_repo_url" {
  value = aws_ecr_repository.ecr_sna_repo.repository_url
}
