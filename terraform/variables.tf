variable "aws_region" {
  type    = string
  default = "eu-south-2"
}

variable "cluster_name" {
  type    = string
  default = "bizzaway-tech"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "eks_user" {
  type      = string
  default   = "tech_challenge"
  sensitive = true
}

variable "account_id" {
  type      = number
  default   = 2
  sensitive = true
}
