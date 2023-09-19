data "aws_region" "current" {}

resource "kubernetes_daemonset" "fluent-bit" {
  metadata {
    name      = "fluent-bit"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = local.labels
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "10%"
      }
    }
    template {
      metadata {
        labels      = local.labels
        annotations = {
          "config-map-version" = base64sha256(jsonencode(kubernetes_config_map.fluent-bit.data)),
        }
      }
      spec {
        #We run fluent bit on the host network for AWS
        #The main reason for this is that it results in a faster startup for fluent-bit, because it can now start up before
        #the CNI has to be ready. When the startup is slower it results in sometimes that an application his logs aren't
        #properly stored because fluent-bit launched slower than the application.
        host_network         = true
        service_account_name = kubernetes_service_account.fluent-bit.metadata.0.name
        container {
          name  = "fluent-bit"
          image = var.fluentbit_image
          resources {
            requests = {
              cpu    = var.k8s_resources_request_cpu
              memory = var.k8s_resources_request_memory
            }
            limits = {
              memory = var.k8s_resources_request_memory
            }
          }
          volume_mount {
            mount_path = "/var/log"
            name       = "varlog"
          }
          volume_mount {
            mount_path = "/var/lib/docker/containers"
            name       = "varlibdockercontainers"
            read_only  = true
          }
          volume_mount {
            mount_path = "/fluent-bit/etc"
            name       = "config"
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "config"
          config_map {
            name         = kubernetes_config_map.fluent-bit.metadata.0.name
            default_mode = "0420"
          }
        }
        toleration {
          operator = "Exists"
        }
      }
    }
  }
}
