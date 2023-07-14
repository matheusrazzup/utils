data "template_file" "kms-policy-doc" {
  template = file("${path.module}/templates/kms-key-policy.tpl")
  vars = {
    account_id   = var.account_id
    admin_role   = var.admin-role-arn
    cluster_name = var.cluster_name
    worker_role  = var.worker-role-arn
  }

}

resource "aws_kms_key" "worker-kms" {
  description             = "K8s worker cmk"
  deletion_window_in_days = 15

  policy = data.template_file.kms-policy-doc.rendered
}

resource "aws_kms_grant" "stackspot-service-linked-role-kms-grant" {
  name              = "stackspot-service-linked-role-kms-grant"
  key_id            = aws_kms_key.worker-kms.key_id
  grantee_principal = "arn:aws:iam::${var.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = ["Decrypt", "Encrypt", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "CreateGrant", "DescribeKey", "ReEncryptFrom", "ReEncryptTo"]
}