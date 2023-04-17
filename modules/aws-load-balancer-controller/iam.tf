locals {
  service_account_name = "aws-load-balancer-controller"
}
resource "aws_iam_role_policy" "aws_load_balancer_eks" {
  policy = file("${path.module}/iam_policy.json")
  name   = "aws-load-balancer-${var.cluster_name}"
  role   = aws_iam_role.aws_load_balancer_role.name
}

resource "aws_iam_role" "aws_load_balancer_role" {
  name               = "aws-load-balancer-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_assume_role.json
}

data "aws_iam_policy_document" "aws_load_balancer_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${local.service_account_name}"]
    }

    principals {
      identifiers = [var.aws_iam_openid_connect_provider_arn]
      type        = "Federated"
    }
  }
}