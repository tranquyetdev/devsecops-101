terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "tranquyet-aws-cloud-practice"
    key    = "networking/site-to-site-vpn/site-a/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}
