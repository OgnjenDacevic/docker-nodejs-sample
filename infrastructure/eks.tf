module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  cluster_name    = "Ognjen-cluster"
  cluster_version = "1.29"
  subnet_ids = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = ["82.117.207.248/32"]


  eks_managed_node_groups  = {
    bottlerocket_nodes = {
      desired_size  = 1
      max_size          = 3
      min_size          = 1

      instance_type = "t3.medium"

      ami_type     = "BOTTLEROCKET_x86_64"

      additional_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }
}