terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }
  backend "s3" {
    bucket = "quyettran-terraform-state-demo"
    key    = "labs/755398944131.acp.preview/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Namespace   = var.namespace
    Environment = var.environment
    Terraform   = true
    Description = "Managed by Terraform"
  }
}

################################################################################
# A shared ECS cluster for all services in the preview environment
################################################################################
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.2.0"

  cluster_name = "${var.namespace}-${var.environment}-cluster"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

################################################################################
# APP: simple-nextjs-app
################################################################################
module "sna" {
  source = "../../modules/simple-nextjs-app"

  # context
  namespace   = var.namespace
  environment = var.environment

  # vpc
  vpc_id                      = local.vpc_id
  public_subnets              = local.public_subnets
  private_subnets             = local.private_subnets
  private_subnets_cidr_blocks = local.private_subnets_cidr_blocks

  # ecs cluster
  ecs_cluster_arn = module.ecs_cluster.arn
  zone_name       = var.zone_name
}

################################################################################
# APP: simple-react-app
################################################################################
module "sra" {
  source = "../../modules/simple-react-app"

  # context
  namespace   = var.namespace
  environment = var.environment

  # website
  zone_name = var.zone_name
}
