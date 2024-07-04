module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  cluster_name    = "Ognjen-cluster"
  cluster_version = "1.30"
  subnet_ids = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = ["82.117.207.248/32"]

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      addon_version            = "v1.30.0-eksbuild.1"
      service_account_role_arn = module.iam_csi_driver_irsa.iam_role_arn
      resolve_conflicts        = "PRESERVE"
    }
  }

  access_entries = {
    task2-github-access_entries = {
      principal_arn = module.iam_assumable_role_with_oidc.iam_role_arn

      policy_associations = {
        task2-eks-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["vegait-training"]
            type       = "namespace"
          }
        }
      }
    }
  }

  eks_managed_node_groups  = {
    bottlerocket_nodes = {
      desired_size  = 1
      max_size          = 3
      min_size          = 1

      instance_type = "t3.small"

      ami_type     = "BOTTLEROCKET_x86_64"

      additional_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }
}
