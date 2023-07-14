resource "aws_efs_file_system" "stackspot_efs" {
  performance_mode = "generalPurpose"
  encrypted        = true
  kms_key_id       = aws_kms_key.stackspot_efs_key.arn
  throughput_mode  = "elastic"

  depends_on = [
    aws_kms_key.stackspot_efs_key
  ]
}

resource "aws_efs_mount_target" "efs-mount-target" {
  for_each       = data.aws_subnet_ids.getsubnets_private.ids
  file_system_id = aws_efs_file_system.stackspot_efs.id
  subnet_id      = each.value
  security_groups = [
    aws_security_group.efs_security_group.id
  ]

  depends_on = [
    aws_efs_file_system.stackspot_efs,
    aws_security_group.efs_security_group
  ]
}