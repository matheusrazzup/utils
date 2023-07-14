terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

data "aws_eks_cluster_auth" "eks_cluster_auth_data" {
  name = "${var.cluster_name}"
}

provider "helm" {
  kubernetes {
    host                   = "${var.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${var.cluster_certificate}")
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth_data.token
  }
}

