resource "kubernetes_service_account" "fluent-bit" {
  metadata {
    name      = local.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluent-bit-role.arn
    }
  }
}

resource "kubernetes_cluster_role_binding" "fluent-bit" {
  metadata {
    name = "fluent-bit"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.fluent-bit.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.fluent-bit.metadata.0.name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "fluent-bit" {
  metadata {
    name = "fluent-bit"
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "update"]
  }
}
