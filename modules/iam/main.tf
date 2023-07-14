locals {
  k8s_roles = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

resource "aws_iam_role" "admin-role" {
  name = "admin-role"

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
  name = "worker-role"

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
