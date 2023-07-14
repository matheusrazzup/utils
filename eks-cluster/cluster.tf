resource "aws_kms_key" "eks" {
  description = "${var.cluster_name} eks KMS"
}

module "eks" {

  providers = {
    kubernetes = kubernetes.k8s
  }

  version                                        = "17.1.0"
  source                                         = "terraform-aws-modules/eks/aws"
  cluster_name                                   = "${var.cluster_name}"
  write_kubeconfig                               = false
  manage_cluster_iam_resources                   = false
  cluster_iam_role_name                          = aws_iam_role.admin_role.id
  manage_worker_iam_resources                    = false
  cluster_create_security_group                  = false
  cluster_security_group_id                      = aws_security_group.controlplane.id
  worker_create_security_group                   = false
  worker_security_group_id                       = aws_security_group.worker_group.id
  cluster_version                                = "${var.cluster_version}"
  cluster_endpoint_private_access                = false
  cluster_endpoint_public_access                 = true
  subnets                                        = data.aws_subnets.private.ids
  vpc_id                                         = sort(data.aws_vpcs.vpc.ids)[0]
  enable_irsa                                    = true
  cluster_enabled_log_types                      = ["api", "audit", "authenticator", "scheduler", "controllerManager"]
  cluster_endpoint_private_access_cidrs          = concat([for s in data.aws_subnet.private : s.cidr_block], var.cidrs_allowed_for_cluster_endpoint)
  cluster_endpoint_public_access_cidrs           = var.cidrs_allowed_for_cluster_endpoint
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  workers_group_defaults = {
    ami_id                    = data.aws_ssm_parameter.golden_ami.value
    iam_instance_profile_name = "${var.node_group_role_name}"
  }

  map_roles = concat([
      {
        rolearn  = aws_iam_role.workers_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }], [for role in var.roles_allowed_to_access_cluster : {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.self.id}:role/${split("=", role)[0]}"
        username = "cluster-admin"
        groups   = ["${split("=", role)[1]}"]
      }]
  )

}