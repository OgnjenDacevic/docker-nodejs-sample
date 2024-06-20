variable "vpc_cidr" {
    type = string
    default = ""
}

data "aws_availability_zones" "available" {
  state = "available"
}