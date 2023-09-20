resource "aws_prometheus_workspace" "prometheus" {
  alias = "prometheus-k8s-${local.cluster_name}"

  logging_configuration {
    log_group_arn = "${aws_cloudwatch_log_group.prometheus_logs.arn}:*"
  }
}

resource "aws_cloudwatch_log_group" "prometheus_logs" {
  name = "/prometheus-k8s-${local.cluster_name}"
}


data "aws_iam_policy_document" "prometheus_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:*:*"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "prometheus" {
  name               = "prometheus-${local.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.prometheus_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "xray" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = aws_iam_role.prometheus.name
}

data "aws_iam_policy_document" "prometheus" {
  statement {
    actions = [
      "aps:RemoteWrite",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata",
    ]
    resources = [aws_prometheus_workspace.prometheus.arn]
  }
}

resource "aws_iam_role_policy" "prometheus" {
  policy   = data.aws_iam_policy_document.prometheus.json
  role     = aws_iam_role.prometheus.id
}
