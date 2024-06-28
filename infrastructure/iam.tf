module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "Ognjen-policy"
  description = "Push images into ECR"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage",
                "ecr:DescribeImages"
            ],
            "Resource": "${module.ecr.repository_arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:AccessKubernetesApi",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "sts:AssumeRoleWithWebIdentity"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}

module "iam-assumable-role-with-oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role = true
  role_name = "Ognjen-github-actions-role"
  provider_url = module.iam_github_oidc_provider.url


  oidc_subjects_with_wildcards = ["repo:OgnjenDacevic/docker-nodejs-sample:*"]
  role_policy_arns = [module.iam_policy.arn]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
}

module "iam_role_for_service_accounts_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "Ognjen-role-for-load-balancer-controller"

  attach_load_balancer_controller_policy = true
  
  oidc_providers = {
    github = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["eks-load-balancer-controller:${var.service_account_name}"]
    }
  }
}


module "iam_csi_driver_irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "ognjen-csi-irsa"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}