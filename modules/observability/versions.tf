terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    helm = {
      source = "hashicorp/helm"
    }
    template = {
      source = "hashicorp/template"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1, < 2.0.0"
    }
  }
  required_version = ">= 0.14"
}
