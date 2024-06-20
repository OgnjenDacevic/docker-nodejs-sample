resource "helm_release" "bitnami_psql" {
  count      = 1
  name       = "bitnami_postgresql"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "10.3.11"

  set {
    name  = "postgresqlPassword"
    value = "your_password"
  }

  set {
    name  = "postgresqlUsername"
    value = "your_username"
  }

  set {
    name  = "postgresqlDatabase"
    value = "your_database"
  }
}

resource "helm_release" "alb_controller" {
  count      = 1
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.5.3"
  namespace  = "load-balancer-service-account"

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
    name  = "enableServiceMutatorWebhook"
    value = "false"
  }
}
