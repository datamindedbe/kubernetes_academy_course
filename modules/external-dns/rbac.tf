locals {
  service_account_name = "external-dns-sa"
}
resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = local.service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" : aws_iam_role.external_dns.arn
    }
  }
}


resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata.0.name
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata.0.name
    namespace = kubernetes_service_account.external_dns.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }
  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
    verbs      = ["get","watch","list"]
  }
  rule {
    api_groups = ["extensions","networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get","watch","list"]
  }
  rule {
    api_groups     = [""]
    resources      = ["nodes"]
    verbs          = ["list","watch"]
  }
}
