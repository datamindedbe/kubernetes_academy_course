locals {
  aws_region         = "eu-west-1"
  account_id         = "299641483789"
  academy_user       = "kubernetesparticipant"
  default_passphrase = "Data Minded r0cks!"
  groupname          = "kubernetes-workshop"
  cluster_name       = "k8s-${random_string.cluster_suffix.result}"
  tcp_protocol_code  = 6

}

resource "random_string" "cluster_suffix" {
  length  = 6
  special = false
}
