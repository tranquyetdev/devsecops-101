terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }
  backend "s3" {
    bucket = "quyettran-terraform-state-demo"
    key    = "labs/755398944131.sra.preview.simple-react-app/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3_static_website_cf" {
  source = "../../../modules/s3-static-website-cf"

  bucket_name = "${var.vertical}-${var.environment}-${var.app_id}"
  zone_name   = var.zone_name
  subdomain   = "${var.environment}-${var.app_id}"
}
