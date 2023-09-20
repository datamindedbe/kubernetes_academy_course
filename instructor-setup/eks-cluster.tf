data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    tier = "private"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.9.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.27"
  subnet_ids      = data.aws_subnets.private.ids
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.large"]
    pre_bootstrap_user_data = local.ssm_userdata
    iam_role_additional_policies = {"ssm": "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"}
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
  cluster_enabled_log_types = ["api", "audit"] //, "authenticator", "controllerManager","scheduler"]

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  eks_managed_node_groups = {
    default_node_group = {
      min_size     = 0
      max_size     = 3
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
