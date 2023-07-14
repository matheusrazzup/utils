terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }

    helm = {
      source = "hashicorp/helm"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1, < 2.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.11.1, < 2.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">= 2.1.0, < 3.0.0"
    }
  }
  required_version = ">= 0.14"
}
