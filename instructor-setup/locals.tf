locals {
  aws_region         = "eu-west-1"
  account_id         = "299641483789"
  academy_user       = "dockerkubernetesparticipant"
  default_passphrase = "Data Minded r0cks!"
  groupname          = "dockerkubernetes-workshop"
  cluster_name       = "docker-k8s-${random_string.cluster_suffix.result}"
}

resource "random_string" "cluster_suffix" {
  length = 6
}
