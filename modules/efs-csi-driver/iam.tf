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

data "aws_iam_role" "eks_controlplane_role" {
  name = var.eks_controlplane_role
}

data "aws_iam_role" "eks_worker_role" {
  name = var.eks_worker_role
}

data "aws_iam_policy_document" "k8s-extras-csi-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAvailabilityZones"
    ]
    resources = [
    "*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:DescribeTags",
      "elasticfilesystem:DeleteAccessPoint",
      "elasticfilesystem:UntagResource",
      "elasticfilesystem:TagResource",
      "elasticfilesystem:ListTagsForResource",
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeAccountPreferences",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DeleteTags"
    ]
    resources = [
    "*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]
    resources = [
    "*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DeleteAccessPoint",
    ]
    resources = [
    "*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "k8s-extras-csi-policy" {
  name   = "k8s-extras-csi-policy-${var.cluster_name}"
  policy = data.aws_iam_policy_document.k8s-extras-csi-policy-document.json
}

resource "aws_iam_role_policy_attachment" "k8s-eks-csi-driver-role-attachment" {
  policy_arn = aws_iam_policy.k8s-extras-csi-policy.arn
  role       = aws_iam_role.k8s-eks-csi-driver-role.name
}