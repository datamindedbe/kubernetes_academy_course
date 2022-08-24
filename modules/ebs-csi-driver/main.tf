locals {
  service_account_name = "ebs-csi-controller-sa"
  extra_tags           = join(",", [for k, v in var.extra_tags : "${k}=${v}"])
}

resource "helm_release" "aws_ebs_csi_driver" {
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.6.11"
  values = [
    <<EOF
image:
  repository: "k8s.gcr.io/provider-aws/aws-ebs-csi-driver"
  tag: ${var.image_version}

sidecars:
  provisioner:
    image:
      repository: "k8s.gcr.io/sig-storage/csi-provisioner"
      tag: ${var.provisioner_image_version}
    resources:
      limits:
         memory: 100Mi
      requests:
        cpu: 50m
        memory: 100Mi
  attacher:
    image:
      repository: "k8s.gcr.io/sig-storage/csi-attacher"
      tag: ${var.attacher_image_version}
    resources:
      limits:
         memory: 50Mi
      requests:
        cpu: 10m
        memory: 50Mi
  snapshotter:
    image:
      repository: "k8s.gcr.io/sig-storage/csi-snapshotter"
      tag: ${var.snapshotter_image_version}
    resources:
      limits:
         memory: 20Mi
      requests:
        cpu: 10m
        memory: 20Mi
  livenessProbe:
    image:
      repository: "k8s.gcr.io/sig-storage/livenessprobe"
      tag: ${var.livenessprobe_image_version}
    resources:
      limits:
         memory: 20Mi
      requests:
        cpu: 10m
        memory: 10Mi
  resizer:
    image:
      repository: "k8s.gcr.io/sig-storage/csi-resizer"
      tag: ${var.resizer_image_version}
    resources:
      limits:
         memory: 300Mi
      requests:
        cpu: 50m
        memory: 100Mi
  nodeDriverRegistrar:
    image:
      repository: "k8s.gcr.io/sig-storage/csi-node-driver-registrar"
      tag: ${var.registrar_image_version}
    resources:
      limits:
         memory: 10Mi
      requests:
        cpu: 10m
        memory: 10Mi

controller:
  additionalArgs:
  - --extra-tags=${local.extra_tags}
  replicaCount: 1
  resources:
    limits:
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi
  serviceAccount:
    name: ${local.service_account_name}
    annotations:
      "eks.amazonaws.com/role-arn": ${aws_iam_role.aws_ebs_csi_driver.arn}
  securityContext:
    runAsUser: 65532
node:
  resources:
    limits:
      memory: 40Mi
    requests:
      cpu: 10m
      memory: 40Mi
  tolerateAllTaints: true
EOF
  ]
}