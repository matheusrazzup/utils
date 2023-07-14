resource "aws_iam_role" "admin_role" {
  name = "admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    cluster = "${var.cluster_name}"
  }
}

resource "aws_iam_role" "workers_role" {
  name = "workers-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    cluster = "${var.cluster_name}"
  }
}

resource "aws_iam_role_policy_attachment" "admin-role-attach" {
  for_each = toset(["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"])
  role       = aws_iam_role.admin_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "workers-role-attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.workers_role.name
  policy_arn = each.value
}