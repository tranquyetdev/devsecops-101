terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }
  backend "s3" {
    bucket = "quyettran-terraform-state-demo"
    key    = "labs/755398944131.acp.preview.simple-nextjs-app/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name     = "${var.namespace}-${var.environment}-${var.app_id}"
  app_name = var.app_name
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Name        = local.name
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}
