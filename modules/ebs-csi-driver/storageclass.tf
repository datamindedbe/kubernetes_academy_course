resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type      = "gp3"
    encrypted = "true"
  }

  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Delete"
}
