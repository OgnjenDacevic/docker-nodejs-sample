variable "vpc_cidr" {
    type = string
    default = ""
}

variable "default_region" {
    type = string
    default = ""
}

data "aws_availability_zones" "available" {
  state = "available"
}