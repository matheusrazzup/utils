output "admin-role-arn" {
  value = aws_iam_role.admin-role.arn
}

output "worker-role-arn" {
  value = aws_iam_role.worker-role.arn
}

output "worker-role-name" {
  value = aws_iam_role.worker-role.name
}

output "worker-instance-profile-name" {
  value = aws_iam_instance_profile.workers.name
}
