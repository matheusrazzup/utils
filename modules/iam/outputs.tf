output "admin-role-arn" {
  value = aws_iam_role.admin-role.arn
}

output "worker-role-arn" {
  value = aws_iam_role.worker-role.arn
}

output "worker-instance-profile-name" {
  value = aws_iam_instance_profile.workers.name
}