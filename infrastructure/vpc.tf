module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "advanced-workshop-vpc"
  cidr = module.subnet_addrs.base_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = [lookup(module.subnet_addrs.network_cidr_blocks, "Private subnet 1", ""),
                     lookup(module.subnet_addrs.network_cidr_blocks, "Private subnet 2", ""),
                     lookup(module.subnet_addrs.network_cidr_blocks, "Private subnet 3", "")]
  public_subnets  = [lookup(module.subnet_addrs.network_cidr_blocks, "Public subnet 1", ""),
                     lookup(module.subnet_addrs.network_cidr_blocks, "Public subnet 2", ""),
                     lookup(module.subnet_addrs.network_cidr_blocks, "Public subnet 3", "")]

  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
}