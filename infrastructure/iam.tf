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
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage",
                "ecr:DescribeImages"
            ],
            "Resource": "*"
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
  version = "5.39.1"
  create_role = true
  role_name = "Ognjen-github-actions-role"
  provider_url = module.iam_github_oidc_provider.url

  oidc_subjects_with_wildcards = ["repo:OgnjenDacevic/docker-nodejs-sample*"]
  role_policy_arns = [module.iam_policy.arn]
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
