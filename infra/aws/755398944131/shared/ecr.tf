# Create ECR repository for simple-nextjs-app
resource "aws_ecr_repository" "ecr_sna_repo" {
  name                 = "${var.namespace}/simple-nextjs-app"
  image_tag_mutability = "IMMUTABLE"
  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}

output "ecr_sna_repo_url" {
  value = aws_ecr_repository.ecr_sna_repo.repository_url
}
