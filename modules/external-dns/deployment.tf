resource "kubernetes_deployment" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
  }
  spec {
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "50%"
      }
    }
    selector {
      match_labels = { "app": "external-dns"}
    }
    template {
      metadata {
        labels = { "app" : "external-dns" }
      }
      spec {
        service_account_name = local.service_account_name
        security_context {
          fs_group = "65534"
        }
        container {
          name  = "external-dns"
          image = "registry.k8s.io/external-dns/external-dns:v0.13.6"
          args  = [
            "--source=service",
            "--source=ingress",
            "--provider=aws",
            "--policy=upsert-only",
            "--aws-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=${var.hosted_zone_id}"
          ]
        }
      }
    }
  }
}