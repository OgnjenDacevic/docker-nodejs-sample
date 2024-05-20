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

module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"
  base_cidr_block = var.vpc_cidr

  networks = [
    {
      name = "Public subnet 1"
      new_bits = 2
    },
    {
      name = "Public subnet 2"
      new_bits = 2
    },
    {
      name = "Public subnet 3"
      new_bits = 2
    },
    {
      name = "Private subnet 1"
      new_bits = 8
    },
    {
      name = "Private subnet 2"
      new_bits = 8
    },
    {
      name = "Private subnet 3"
      new_bits = 8
    }
  ]

  

}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "advanced-workshop-vpc"
  cidr = module.subnet_addrs.base_cidr_block
  
  azs             = data.aws_availability_zones.available.names
  private_subnets = [module.subnet_addrs.networks[3].cidr_block,
            module.subnet_addrs.networks[4].cidr_block,
            module.subnet_addrs.networks[5].cidr_block]
  public_subnets  = [module.subnet_addrs.networks[0].cidr_block,
            module.subnet_addrs.networks[1].cidr_block,
            module.subnet_addrs.networks[2].cidr_block]

  # NAT gateway
  enable_nat_gateway = true
  single_nat_gateway = true
}
