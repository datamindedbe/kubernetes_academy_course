variable "namespace" {}
variable "aws_iam_openid_connect_provider_url" {}
variable "aws_iam_openid_connect_provider_arn" {}
variable "prometheus_role_arn" {}
variable "prom_region" {}
variable "prom_endpoint" {}
variable "image_version" {
  default = "v2.5.0"
}
variable "cluster_name" {}