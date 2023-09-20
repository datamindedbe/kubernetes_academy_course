resource "kubernetes_config_map" "otel_config" {
  metadata {
    name      = "kube-state-metrics-otel"
    namespace = var.namespace
  }
  data = {
    "config.yaml" = <<EOF
receivers:
  prometheus:
    config:
      global:
        scrape_interval: 1m
        scrape_timeout: 10s
      scrape_configs:
      - job_name: "kube-state-metrics"
        static_configs:
        - targets: [ 0.0.0.0:8080 ]
          labels:
            cluster: ${var.cluster_name}
  awsecscontainermetrics:
    collection_interval: 20s
extensions:
  sigv4auth:
    region: "${var.prom_region}"
exporters:
  prometheusremotewrite:
    endpoint: ${var.prom_endpoint}api/v1/remote_write
    auth:
      authenticator: sigv4auth

service:
  extensions: [sigv4auth]
  pipelines:
    metrics:
      receivers: [prometheus]
      exporters: [prometheusremotewrite]
EOF
  }
}