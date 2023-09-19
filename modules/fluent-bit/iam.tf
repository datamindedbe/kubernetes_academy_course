data "aws_iam_policy_document" "fluent-bit-assume-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${local.service_account_name}"]
    }

    principals {
      identifiers = [var.aws_iam_openid_connect_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "fluent-bit-role" {
  name                = "fluent-bit"
  assume_role_policy  = data.aws_iam_policy_document.fluent-bit-assume-policy.json
}

resource "aws_iam_role_policy" "fluent-bit" {
  policy = data.aws_iam_policy_document.fluent-bit.json
  role   = aws_iam_role.fluent-bit-role.id
}

data "aws_iam_policy_document" "fluent-bit" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.fluent-bit.arn}:*"]
  }
  statement {
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.fluent-bit.arn}:*:*:*"]
  }
}