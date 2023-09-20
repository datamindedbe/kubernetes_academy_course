resource "kubernetes_deployment" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "kube-state-metrics"
      }
    }
    replicas = 1
    template {
      metadata {
        labels = {
          app = "kube-state-metrics"
        }
        annotations = {
          otel_config = base64sha256(jsonencode(kubernetes_config_map.otel_config.data))
        }
      }
      spec {
        service_account_name = kubernetes_service_account.kube_state_metrics.metadata.0.name
        container {
          name  = "kube-state-metrics"
          image = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:${var.image_version}"
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_user                = "65534"
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          args = [
            "--resources=daemonsets,deployments",
            "--namespaces=kube-system",
            "--metric-allowlist=kube_deployment_.*|kube_daemonset.*",
          ]
          port {
            container_port = 8080
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "8080"
            }
            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
          resources {
            requests = {
              cpu    = "50m"
              memory = "128Mi"
            }
            limits = {
              memory = "128Mi"
            }
          }
        }

        container {
          name  = "aws-otel-collector"
          image = "amazon/aws-otel-collector:v0.32.0"
          security_context {
            run_as_user                = "65532"
            run_as_non_root            = true
            read_only_root_filesystem  = true
            allow_privilege_escalation = false
          }
          env {
            name  = "AWS_DEFAULT_REGION"
            value = var.prom_region
          }
          env {
            name  = "AWS_REGION"
            value = var.prom_region
          }
          env {
            name  = "AWS_ROLE_ARN"
            value = var.prometheus_role_arn
          }
          env {
            name  = "AWS_STS_REGIONAL_ENDPOINTS"
            value = "regional"
          }
          env {
            name  = "AWS_WEB_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
          }
          args = ["--config=/tmp/config.yaml"]
          resources {
            requests = {
              cpu    = "32m"
              memory = "128Mi"
            }
            limits = {
              memory = "128Mi"
            }
          }
          volume_mount {
            mount_path = "/tmp/config.yaml"
            name       = "otel-config"
            sub_path   = "config.yaml"
          }
          volume_mount {
            mount_path = "/var/run/secrets/eks.amazonaws.com/serviceaccount"
            name       = "aws-iam-token"
          }
        }
        volume {
          name = "otel-config"
          config_map {
            name = kubernetes_config_map.otel_config.metadata.0.name
          }
        }
        volume {
          name = "aws-iam-token"
          projected {
            sources {
              service_account_token {
                audience           = "sts.amazonaws.com"
                expiration_seconds = 86400
                path               = "token"
              }
            }
          }
        }
      }
    }
  }
}
