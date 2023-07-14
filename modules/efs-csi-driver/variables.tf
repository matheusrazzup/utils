variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "csi_service_account_name" {
  type = string
}

variable "csi_role_name" {
  type = string
}

variable "eks_worker_role" {
  type = string
}

variable "eks_controlplane_role" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_name" {
  type = string
}