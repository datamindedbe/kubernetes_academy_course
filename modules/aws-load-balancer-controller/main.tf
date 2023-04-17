resource "helm_release" "aws_load_balancer_controller" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.5.0"
  values = [
    <<EOF
replicaCount: 1

clusterName: ${var.cluster_name}
serviceAccount:
  create: false
  name: ${local.service_account_name}
resources:
  limits:
    memory: 300Mi
  requests:
    cpu: 100m
    memory: 300Mi
EOF
  ]
}