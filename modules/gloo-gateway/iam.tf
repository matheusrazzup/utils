resource "aws_iam_role" "lambda-eks" {
  name = "lambda-eks"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_oidc_id}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_oidc_id}:sub" : [
              "system:serviceaccount:gloo-system:discovery",
              "system:serviceaccount:gloo-system:gateway-proxy"
            ],
            "oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_oidc_id}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda-eks-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunction",
      "lambda:InvokeAsync"
    ]
    resources = ["arn:aws:lambda:*:${var.account_id}:function:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "lambda:ListFunctions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda-eks-policy-document" {
  name        = "lambda-gloo-gateway"
  description = "Policy to trigger lambda by Gloo Gateway"
  policy      = data.aws_iam_policy_document.lambda-eks-policy-document.json
}

resource "aws_iam_role_policy_attachment" "lambda-eks-role-policy-attachment" {
  policy_arn = aws_iam_policy.lambda-eks-policy-document.arn
  role       = aws_iam_role.lambda-eks.name
}