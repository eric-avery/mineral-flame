data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "mineral-flame-vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.name}-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mineral-flame-vpc.id]
  }

  filter {
    name = "tag:Name"
    values = ["${var.name}-vpc-private-${data.aws_region.current.name}*"]
  }
}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.cluster_version}-v*"]
  }
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:name"
    values = ["default-vpc"]
  }
}