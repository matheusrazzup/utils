resource "aws_eks_node_group" "ng" {
  node_group_name = "${var.cluster_name}-ng"
  cluster_name    = module.eks.cluster_id
  node_role_arn   = aws_iam_role.workers_role.arn
  subnet_ids      = data.aws_subnets.private.ids
  instance_types  = ["${var.workers_instance_type}"] # eg. t3a.medium
  capacity_type   = "ON_DEMAND" # eg. ON_DEMAND / SPOT

  scaling_config {
    desired_size = var.ng_desired_size
    max_size     = var.ng_max_size
    min_size     = var.ng_min_size
  }

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.default_version
  }

  ## If you like to keep the same node group name when updating the instance type, you will have to delete before destroy. Comment out the lifecycle block or set the value to false, true means that if customer try to rename the nodegroup name the pipeline will fail to avoid customer accidentaly cause a downtime in his cluster
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.eks, aws_launch_template.lt
  ]
}

# Scheduled Scaling Managed Nodes
# resource "aws_autoscaling_schedule" "{{ cluster_name }}-scale_in" {
#   scheduled_action_name  = "Terminate Instances"
#   min_size               = 0
#   max_size               = 0
#   desired_capacity       = 0
#   time_zone              = "America/Sao_Paulo"
#   recurrence             = "{{ asg_stop_schedule }}"
#   autoscaling_group_name = aws_eks_node_group.{{ cluster_name }}-ng.resources[0].autoscaling_groups[0].name

#   depends_on = [
#     aws_eks_node_group.{{ cluster_name }}-ng
#   ]
# }

# resource "aws_autoscaling_schedule" "{{ cluster_name }}-scale_out" {
#   scheduled_action_name  = "Startup Instances"
#   min_size               = {{ asg_min_size }}
#   max_size               = {{ asg_max_size }}
#   desired_capacity       = {{ asg_desired_capacity }}
#   time_zone              = "America/Sao_Paulo"
#   recurrence             = "{{ asg_start_schedule }}"
#   autoscaling_group_name = aws_eks_node_group.{{ cluster_name }}-ng.resources[0].autoscaling_groups[0].name

#   depends_on = [
#     aws_eks_node_group.{{ cluster_name }}-ng
#   ]
# }