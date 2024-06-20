module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"
  base_cidr_block = var.vpc_cidr


  networks = [
    {
      name = "Public subnet 1"
      new_bits = 8
    },
    {
      name = "Public subnet 2"
      new_bits = 8
    },
    {
      name = "Public subnet 3"
      new_bits = 8
    },
    {
      name = "Private subnet 1"
      new_bits = 2
    },
    {
      name = "Private subnet 2"
      new_bits = 2
    },
    {
      name = "Private subnet 3"
      new_bits = 2
    }
  ]
}