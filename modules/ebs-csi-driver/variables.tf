variable "aws_iam_openid_connect_provider_url" {}
variable "aws_iam_openid_connect_provider_arn" {}
variable "cluster_name" {}
variable "extra_tags" {}
variable "image_version" {
  default = "v1.4.0"
}
variable "provisioner_image_version" {
  default = "v3.1.0"
}
variable "attacher_image_version" {
  default = "v3.4.0"
}
variable "snapshotter_image_version" {
  default = "v6.0.1"
}
variable "livenessprobe_image_version" {
  default = "v2.5.0"
}
variable "resizer_image_version" {
  default = "v1.4.0"
}
variable "registrar_image_version" {
  default = "v2.5.1"
}