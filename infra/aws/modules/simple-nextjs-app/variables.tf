# Context
variable "namespace" {
  description = "Namespace"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

# VPC
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "private_subnets_cidr_blocks" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
}

# ECS Cluster
variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

# DNS
variable "zone_name" {
  description = "Zone name"
  type        = string
}
