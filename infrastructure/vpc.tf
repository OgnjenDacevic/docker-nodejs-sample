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

  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
}
