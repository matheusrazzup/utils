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

variable "custom_web_acl" {
  type    = bool
  default = false
}