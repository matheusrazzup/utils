locals {
  k8s_roles = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

resource "aws_iam_role" "admin-role" {
  name = "observability-admin-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.account_id}:root"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "worker-role" {
  name = "observability-worker-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8s-worker-role-policies" {
  count      = length(local.k8s_roles)
  policy_arn = local.k8s_roles[count.index]
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = var.cluster_name
  role        = aws_iam_role.worker-role.id

  path = "/"

  lifecycle {
    create_before_destroy = true
  }
}

#data "aws_iam_policy_document" "observability" {
#
#  statement {
#    actions = [
#      "s3:ListBucket",
#      "s3:GetObject",
#      "s3:DeleteObject",
#      "s3:PutObject"
#    ]
#
#    resources = [
#      "arn:aws:s3:::${var.thanos_bucket_name}/*",
#      "arn:aws:s3:::${var.thanos_bucket_name}"
#    ]
#  }
#}

# IRSA
#resource "aws_iam_policy" "observability" {
#
#  name_prefix = "stackspot"
#  description = "EKS observability policy for cluster ${var.cluster_name}"
#  policy      = data.aws_iam_policy_document.observability.json
#}

#module "iam_assumable_role_observability" {
#  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#  create_role                   = true
#  role_name                     = "tools-thanos.${var.cluster_name}"
#  provider_url                  = var.cluster_oidc_provider
#  role_policy_arns              = [length(aws_iam_policy.observability) >= 1 ? aws_iam_policy.observability.arn : ""]
#  oidc_fully_qualified_subjects = ["system:serviceaccount:observability:observability-tools-thanos"]
#}



