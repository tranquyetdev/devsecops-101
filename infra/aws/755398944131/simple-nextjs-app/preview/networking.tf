# =============== Fetch shared networking resouces ===============

data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-shared-vpc"]
  }
}

# Filter private subnets by vpc id
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

locals {
  vpc_id                      = data.aws_vpc.selected.id
  vpc_cidr                    = data.aws_vpc.selected.cidr_block
  public_subnets              = data.aws_subnets.public.ids
  public_subnets_cidr_blocks  = [for s in data.aws_subnet.public : s.cidr_block]
  private_subnets             = data.aws_subnets.private.ids
  private_subnets_cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
}
