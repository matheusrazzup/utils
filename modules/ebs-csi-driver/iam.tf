resource "aws_iam_role_policy_attachment" "k8s-csi-role-policie" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.k8s-eks-csi-driver-role.name
}

resource "aws_iam_role" "k8s-eks-csi-driver-role" {
  name = var.csi_role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer), length(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer)) - 1)}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer), length(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer)) - 1)}:sub" : "system:serviceaccount:kube-system:${var.csi_service_account_name}"
          }
        }
      }
    ]
  })
}