module "karpenter_assumable_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "3.6.0"
  create_role = true
  role_name   = "KarpenterNodeRole-${var.cluster_name}"
  tags = {
    Role = "KarpenterNodeRole-${var.cluster_name}"
  }
  provider_url  = var.cluster_oidc_provider
  provider_urls = [var.cluster_oidc_provider]
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:karpenter"]

}

data "aws_iam_policy_document" "karpenter_controller_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:RunInstances",
      "ec2:CreateTags",
      "iam:PassRole",
      "ec2:TerminateInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name   = "karpenter_controller_policy_${var.cluster_name}"
  policy = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
  role       = "KarpenterNodeRole-${var.cluster_name}"

  depends_on = [
    module.karpenter_assumable_role
  ]
}
