data "template_file" "launch_template_userdata" {
  template = file("${path.module}/userdata.sh.tpl")

  vars = {
    cluster_name        = "${var.cluster_name}"
    endpoint            = module.eks.cluster_endpoint
    cluster_auth_base64 = module.eks.cluster_certificate_authority_data

    bootstrap_extra_args = ""
    kubelet_extra_args   = ""
  }
}

data "aws_ssm_parameter" "golden_ami" {
  name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2/recommended/image_id"
}

## This is based on the LT that EKS would create if no custom one is specified (aws ec2 describe-launch-template-versions --launch-template-id xxx)
## There are several more options one could set but you probably dont need to modify them
## you can take the default and add your custom AMI and/or custom tags

## Trivia: AWS transparently creates a copy of your LaunchTemplate and actually uses that copy then for the node group. If you DONT use a custom AMI,
## then the default user-data for bootstrapping a cluster is merged in the copy.
resource "aws_launch_template" "lt" {
  description            = "Default Launch-Template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = "${var.ng_vol_size}"
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true

      ## Enable this if you want to encrypt your node root volumes with a KMS/CMK. encryption of PVCs is handled via k8s StorageClass tho
      ## you also need to attach data.aws_iam_policy_document.ebs_decryption.json from the disk_encryption_policy.tf to the KMS/CMK key then !!
      # kms_key_id            = var.kms_key_arn
    }
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.worker_group.id]
  }

  image_id = data.aws_ssm_parameter.golden_ami.value
  user_data = base64encode(
    data.template_file.launch_template_userdata.rendered,
  )


  ## Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-lt"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}