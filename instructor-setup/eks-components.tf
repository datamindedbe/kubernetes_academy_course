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

module "external-dns" {
  source                              = "../modules/external-dns"
  cluster_name                        = local.cluster_name
  aws_iam_openid_connect_provider_arn = module.eks.oidc_provider_arn
  aws_iam_openid_connect_provider_url = module.eks.cluster_oidc_issuer_url
  hosted_zone_id                      = aws_route53_zone.waydata.id
}

module "k8s-fluent-bit" {
  source                              = "../modules/fluent-bit"
  aws_iam_openid_connect_provider_arn = module.eks.oidc_provider_arn
  aws_iam_openid_connect_provider_url = module.eks.cluster_oidc_issuer_url
  fluentbit_image                     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:2.23.3"
}

module "metrics-server" {
  source = "../modules/metrics-server"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}