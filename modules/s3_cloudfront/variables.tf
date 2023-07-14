variable "bucket_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "domains" {
  type = list(string)
}

variable "webacl_arn" {
  type    = string
  default = ""
}

variable "roles_allowed" {
  type = list(string)
}