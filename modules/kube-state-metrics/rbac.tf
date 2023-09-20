resource "kubernetes_service_account" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.prometheus_role_arn
    }
  }
}

resource "kubernetes_cluster_role_binding" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kube_state_metrics.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_state_metrics.metadata.0.name
    namespace = kubernetes_service_account.kube_state_metrics.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"
  }
  rule {
    api_groups = [""]
    resources = [
      "configmaps",
      "namespaces",
      "endpoints",
      "nodes",
      "pods",
      "replicationcontrollers",
      "secrets",
      "services",
      "persistentvolumeclaims",
      "persistentvolumes",
    ]
    verbs = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["daemonsets", "statefulsets", "replicasets"]
    verbs      = ["list", "watch"]
  }
  # make sure the addon-resizer can update the deployment
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["list", "watch", "get", "update"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
    verbs      = ["list", "watch"]
  }
}
