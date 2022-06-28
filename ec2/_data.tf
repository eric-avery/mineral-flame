data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

data "aws_vpc" "mineral-flame-vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.name}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.mineral-flame-vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.name}-public-${data.aws_region.current.name}a"]
  }

}