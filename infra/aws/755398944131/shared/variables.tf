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

# variable "environment" {
#   description = "Environment"
#   type        = string
#   default     = "preview"
# }

variable "app_id" {
  description = "Application Id"
  type        = string
  default     = "simple-react-app"
}
