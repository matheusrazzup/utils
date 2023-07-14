variable "aws_region" {
  type = string
}

variable "loki_bucket_name" {
  type = string
}

variable "enable_promstack" {
  type        = bool
  default     = true
  description = "should module deploy promstack"
}

variable "enable_odigos" {
  type        = bool
  default     = true
  description = "should module deploy odigos"
}