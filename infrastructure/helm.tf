resource "helm_release" "bitnamipsql" {
  name       = "ognjen-eks-postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "~> 15.5.0"
  create_namespace = true
  namespace = "vegait-training"
  

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
  set {
    name  = "primary.persistence.enabled"
    value = true
  }
  set {
    name  = "primary.persistence.volumeName"
    value = "ognjen-eks-persistent-volume"
  }
  set {
    name = "primary.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name = "containerPorts.postgresql"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "port", "")
  }
  set {
    name = "primary.persistence.storageClass"
    value = kubernetes_storage_class.eks_storage_class.metadata[0].name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  
  set {
    name = "primary.persistence.size"
    value = "8Gi" 
  }
}



resource "kubernetes_storage_class" "eks_storage_class" {
  metadata {
    name = "ognjen-eks-storage-class"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    "encrypted" = "true"
  }
}

resource "helm_release" "alb_controller" {
  count      = 1
  name       = "ognjen-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.8.1"
  namespace  = "eks-load-balancer-controller"
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
    value = "load-balancer-controller"
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
