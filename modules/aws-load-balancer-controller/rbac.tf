resource "kubernetes_service_account" "aws_load_balancer" {
  metadata {
    name      = local.service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" : aws_iam_role.aws_load_balancer_role.arn
    }
  }
}