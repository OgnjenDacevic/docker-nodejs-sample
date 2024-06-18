module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  cluster_name    = "Ognjen-cluster"
  cluster_version = "1.29"
  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
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

module "iam-role-for-service-accounts-eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.39.1"
  role_name = "Ognjen-role-for-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    github = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["load-balancer-service-account:load-balancer-controller"]
    }
  }
}