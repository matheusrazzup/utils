resource "aws_security_group" "controlplane" {
  name        = "{{ cluster_name }}"
  description = "EKS control plane security group"
  vpc_id      = sort(data.aws_vpcs.vpc.ids)[0]
  tags = {
      "Name" = "{{ cluster_name }}-eks_cluster_sg"
    }
}

resource "aws_security_group_rule" "controlplane_to_internet_egress" {
  description       = "Allow traffic from control plane to internet"
  protocol          = "-1"
  security_group_id = aws_security_group.controlplane.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_to_https_controlplane_ingress" {
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = aws_security_group.controlplane.id
  source_security_group_id = aws_security_group.worker_group.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group" "worker_group" {
  name        = "{{ cluster_name }}-wg"
  description = "EKS workers nodes security group"
  vpc_id      = sort(data.aws_vpcs.vpc.ids)[0]
  tags = {
      "Name" = "{{ cluster_name }}-eks_wg_sg"
    }
}

resource "aws_security_group_rule" "workers_to_internet_egress" {
  description       = "Allow traffic from worker nodes to internet"
  protocol          = "-1"
  security_group_id = aws_security_group.worker_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_dns_ingress" {
  description              = "Allow DNS communication between workers."
  protocol                 = "udp"
  security_group_id        = aws_security_group.worker_group.id
  from_port                = 53
  to_port                  = 53
  self                     = true
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_to_kubelet_controlplane_ingress" {
  description              = "Allow kubelet traffic from workers nodes to control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.controlplane.id
  source_security_group_id = aws_security_group.worker_group.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_to_workers_ingress" {
  description       = "Allow traffic between workers."
  protocol          = "tcp"
  security_group_id = aws_security_group.worker_group.id
  from_port         = 1
  to_port           = 65535
  self              = true
  type              = "ingress"
}

resource "aws_security_group_rule" "controlplane_to_workers_ingress" {
  description              = "Allow traffic from control plane to workers nodes"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_group.id
  source_security_group_id = aws_security_group.controlplane.id
  from_port                = 1
  to_port                  = 65535
  type                     = "ingress"
}
