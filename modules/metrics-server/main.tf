resource "helm_release" "metrics_server" {
  chart       = "metrics-server"
  repository  = "https://kubernetes-sigs.github.io/metrics-server"
  name        = "k8s-metrics-server"
  version     = "3.8.2"
  namespace   = var.namespace
  keyring     = ""
  max_history = 10
  values = [
    <<EOF
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    memory: 512Mi
image:
  repository: registry.k8s.io/metrics-server/metrics-server
  tag: ${var.image_version}
EOF
  ]
}
