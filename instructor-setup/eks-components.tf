module "ebs-csi-driver" {
  source = "../modules/ebs-csi-driver"

  aws_iam_openid_connect_provider_arn = module.eks.oidc_provider_arn
  aws_iam_openid_connect_provider_url = module.eks.cluster_oidc_issuer_url
  cluster_name                        = local.cluster_name
  extra_tags                          = {}
}

module "aws-load-balancer-controller" {
  source                              = "../modules/aws-load-balancer-controller"
  cluster_name                        = local.cluster_name
  aws_iam_openid_connect_provider_arn = module.eks.oidc_provider_arn
  aws_iam_openid_connect_provider_url = module.eks.cluster_oidc_issuer_url
  vpc_id                              = module.vpc.vpc_id
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}