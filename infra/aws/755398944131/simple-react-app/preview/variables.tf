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
  description = "namespace"
  type        = string
  default     = "sra"
}

variable "app_id" {
  description = "Application Id"
  type        = string
  default     = "simple-react-app"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "preview"
}

variable "zone_name" {
  description = "Zone name"
  type        = string
}
