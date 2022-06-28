module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "10.1.0.0/16"
  azs             = [
      "${data.aws_region.current.name}a", 
      "${data.aws_region.current.name}b", 
      "${data.aws_region.current.name}c"
      ]
  public_subnets  = ["10.1.128.0/20", "10.1.144.0/20", "10.1.160.0/20"]
  private_subnets  = ["10.1.0.0/19", "10.1.32.0/19", "10.1.64.0/19"]
  enable_nat_gateway = true
  enable_vpn_gateway = false
}