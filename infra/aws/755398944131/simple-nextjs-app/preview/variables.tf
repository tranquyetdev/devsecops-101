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
  default     = "sra"
}

variable "app_id" {
  description = "Application Id"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "preview"
}

