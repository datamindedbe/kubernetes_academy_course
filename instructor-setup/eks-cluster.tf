
data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    tier = "private"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 18.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  subnet_ids      = data.aws_subnets.private.ids
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    default_node_group = {
      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn = aws_iam_user.workshop_user.arn
      groups  = ["system:masters"]
    }
  ]

  aws_auth_roles = [
    {
      rolearn = "arn:aws:iam::${local.account_id}:role/AWSReservedSSO_AdministratorAccess_3927b2c3b8ca005c"
      groups  = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    local.account_id
  ]

  tags = {
    Terraform = "true"
  }
}
