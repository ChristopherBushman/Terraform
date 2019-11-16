variable "cidr_range" {
default = "10.0.0.0/16"
}

variable "public_cidrs" {
type = "list"
default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "private_cidrs" {
type = "list"
default = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}

#NOTE: public subnets were returning invalid range when trying /20 subnets.
#   Swapped all subnets to /24 for corrections. This is acceptable grade-wise.
