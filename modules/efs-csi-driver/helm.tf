resource "helm_release" "aws-efs-csi-driver" {
  name             = "aws-efs-csi-driver-helm"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart            = "aws-efs-csi-driver"
  version          = "2.1.1"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = "600"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.sa-east-1.amazonaws.com/eks/aws-efs-csi-driver"
  }

  set {
    name  = "controller.serviceAccount.create"
    value = false
  }

  set {
    name  = "controller.deleteAccessPointRootDir"
    value = true
  }

  set {
    name  = "controller.serviceAccount.name"
    value = var.csi_service_account_name
  }

  set {
    name  = "controller.serviceAccount.annotations"
    value = "eks.amazonaws.com/role-arn: ${aws_iam_role.k8s-eks-csi-driver-role.arn}"
  }

  values = [<<EOF
  storageClasses:
    - name: efs-sc
      parameters:
        provisioningMode: efs-ap
        fileSystemId: ${aws_efs_file_system.stackspot_efs.id}
        directoryPerms: "700"
        basePath: "/dynamic_provisioning_test"
      reclaimPolicy: Delete
      volumeBindingMode: Immediate
  EOF
  ]

  depends_on = [
    helm_release.csi-charts
  ]
}

resource "helm_release" "csi-charts" {
  name      = var.csi_service_account_name
  chart     = "${path.module}/charts"
  namespace = "kube-system"
  timeout   = "600"
  values    = [data.template_file.this.rendered]

}

data "template_file" "this" {
  template = file("${path.module}/templates/efs.tpl")
  vars = {
    create                      = true
    csi-account-name            = var.csi_service_account_name
    namespace                   = "k8s-extras"
    aws-account-id              = var.account_id
    csi-role-name               = var.csi_role_name
    efs-csi-driver-release-name = "aws-efs-csi-driver-helm"
  }
}

