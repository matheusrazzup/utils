terraform {
  required_version = ">= 0.14.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.11.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "1.4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.1.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "1.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "2.1.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "1.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}
