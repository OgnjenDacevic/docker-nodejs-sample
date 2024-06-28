variable "vpc_cidr" {
    type = string
    default = ""
}

variable "default_region" {
    type = string
    default = ""
}

variable "service_account_name" {
  type        = string
  default     = "load-balancer-controller"
  description = "ALB Controller service account name"
}

data "aws_availability_zones" "available" {
  state = "available"
}