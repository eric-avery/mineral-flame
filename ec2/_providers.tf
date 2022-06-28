terraform {
  cloud {
    organization = "ericmckennaavery"
    workspaces {
      name = "foundry-cloudfront"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=4.1.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  default_tags {
   tags = {
     ProvisionedBy = "Terraform"
     Owner         = "EAvery"
     Project       = "mineral-flame"
     Billing       = "mineral-flame"
   }
 }
}