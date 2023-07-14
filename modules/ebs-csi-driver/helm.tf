resource "helm_release" "aws-ebs-csi-driver" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.16.0"

  values = [<<EOF
  controller:
    serviceAccount:
        name: ${var.csi_service_account_name}
        annotations:
            eks.amazonaws.com/role-arn: ${aws_iam_role.k8s-eks-csi-driver-role.arn}
  EOF
  ]
}