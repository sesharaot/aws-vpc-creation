############## Variables ###############
# Token variable
variable "name" {
default = "test"
}

variable "your_aws_region" {
default = "ap-south-1"
}

variable "your_aws_s3_bucket" {
  description = "The name of your AWS S3 bucket"
  type        = string
  default = "test"
}

variable "Env" {
  description = "The name of env"
  type        = string
  default     = "test"
}

variable "Role" {
  type        = string
  default     = "test"
}

variable "Project" {
default = "test"
}

variable "POC" {
default = "SRT"
}

variable "vpc_cidr_block" {
default = "10.0.0.0/16"
}

variable "azs" {
default = ["us-east-1"]
}

variable "private_subnets" {
default = "10.0.0.0/24"
}

variable "public_subnets" {
default = "10.1.0.0/24"

}

variable "enable_nat_gateway" {
default = true
}

variable "enable_vpn_gateway" {
default = false
}
