variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "app_id" {
  description = "Application Id"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}
