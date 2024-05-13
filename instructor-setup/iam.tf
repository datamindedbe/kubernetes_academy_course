# Create IAM users with a default password
resource "aws_iam_user_login_profile" "workshop_login_user" {
  pgp_key = data.local_file.pgp_key_workshop_user.content_base64
  user    = aws_iam_user.workshop_user.name
}

resource "aws_iam_user" "workshop_user" {
  name          = local.academy_user
  path          = "/"
  force_destroy = true
}

data "local_file" "pgp_key_workshop_user" {
  filename = "./gpgkey/public-key-academy-users.gpg"
}

resource "aws_iam_group" "group" {
  name = local.groupname
}

resource "aws_iam_role" "kubernetes_workshop_gitpod_role" {
  name               = "kubernetes-workshop-gitpod-role"
  assume_role_policy = data.aws_iam_policy_document.gitpod_assume_role.json
  inline_policy {
    name   = "gitpod_permissions"
    policy = data.aws_iam_policy_document.gitpod_permissions.json
  }
}

data "aws_iam_policy_document" "gitpod_permissions" {
  statement {
    actions = ["eks:DescribeCluster"]
    resources = ["*"]
    effect  = "Allow"
  }
}

data "aws_iam_policy_document" "gitpod_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "services.gitpod.io/idp:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "services.gitpod.io/idp:sub"
      values   = ["https://github.com/datamindedbe/kubernetes_academy_course"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_connect_provider_gitpod.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_group_policy_attachment" "eks_cluster_policy" {
  # description: This policy provides Kubernetes the permissions it requires to
  # manage resources on your behalf. Kubernetes requires Ec2:CreateTags
  # permissions to place identifying information on EC2 resources including but
  # not limited to Instances, Security Groups, and Elastic Network Interfaces. 
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_group_policy_attachment" "eks_workers_policy" {
  # description: This policy allows Amazon EKS worker nodes to connect to
  # Amazon EKS Clusters. 
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_user_group_membership" "participant_group" {
  user   = aws_iam_user.workshop_user.name
  groups = [aws_iam_group.group.name]
}
