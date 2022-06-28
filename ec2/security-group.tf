module "https_443_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/https-443"
  version             = "~> 4.0"
  name                = "${var.name}-https-sg"
  description         = "Security group with HTTPS ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id              = data.aws_vpc.mineral-flame.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "http_80_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"
  version             = "~> 4.0"
  name                = "${var.name}-http-sg"
  description         = "Security group with HTTP ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id              = data.aws_vpc.mineral-flame.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ssh_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "~> 4.9.0"
  name                = "${var.name}-ssh-sg"
  description         = "Security group that enables ssh"
  vpc_id              = data.aws_vpc.mineral-flame.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

