resource "helm_release" "bitnami_psql" {
  count      = 1
  name       = "bitnami_postgresql"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "10.3.11"

  set {
    name  = "auth.username"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "username", "")
  }

  set {
    name  = "auth.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "password", "")
  }

  set {
    name  = "auth.database"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "dbname", "")
  }
}

resource "helm_release" "alb_controller" {
  depends_on      = [module.eks]
  count      = 1
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.7.2"
  namespace  = "load-balancer-service-account"
  create_namespace = true

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.default_region
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_role_for_service_accounts_eks.iam_role_arn
  }

  set {
    name  = "region"
    value = var.default_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
}
