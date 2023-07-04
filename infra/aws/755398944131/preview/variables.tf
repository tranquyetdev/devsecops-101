variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# DNS
variable "zone_name" {
  description = "Zone name"
  type        = string
}
