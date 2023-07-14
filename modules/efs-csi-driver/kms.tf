resource "aws_kms_key" "stackspot_efs_key" {
  description             = "StackSpot K8S efs cmk"
  deletion_window_in_days = 15

  policy = data.template_file.kms_policy_doc.rendered
}

data "template_file" "kms_policy_doc" {
  template = file("${path.module}/templates/kms-key-policy.tpl")
  vars = {
    controlplane_admin_role = data.aws_iam_role.eks_controlplane_role.arn
    worker_role             = data.aws_iam_role.eks_worker_role.arn
    account_id              = var.account_id
  }
}