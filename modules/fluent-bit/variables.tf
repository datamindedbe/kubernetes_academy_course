variable "namespace" {
  default = "kube-system"
}
variable "k8s_resources_request_cpu" {
  description = "CPU request for the pods"
  type        = string
  default     = "20m"
}
variable "k8s_resources_request_memory" {
  description = "Memory request for the pods"
  type        = string
  default     = "60Mi"
}
variable "aws_iam_openid_connect_provider_url" {}
variable "aws_iam_openid_connect_provider_arn" {}
variable "fluentbit_image" {}
