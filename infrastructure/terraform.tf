terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.48.0"
        }
    }
}
provider "aws" {
  region  = "eu-central-1"
  profile = "terraform"
  default_tags {
    tags = {
      Owner = "Ognjen Dacevic"
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "advanced-workshop-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # NAT gateway
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = true
}
