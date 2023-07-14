data "aws_eks_cluster" "stackspot_cluster" {
  name = var.cluster_name
}

data "aws_caller_identity" "getidentity" {}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

data "aws_vpcs" "getvpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_vpc" "eksvpc" {
  id = element(tolist(data.aws_vpcs.getvpc.ids), 0)
}

data "aws_subnet_ids" "getsubnets_private" {
  vpc_id = element(tolist(data.aws_vpcs.getvpc.ids), 0)

  tags = {
    Name = "prv*"
  }
}

data "aws_subnet_ids" "getsubnets_public" {
  vpc_id = element(tolist(data.aws_vpcs.getvpc.ids), 0)

  tags = {
    Name = "pub*"
  }
}