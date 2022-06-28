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