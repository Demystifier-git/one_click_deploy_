variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones list"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}



variable "instance_type" {
type = string
default = "t3.micro"
}


variable "ami_id" {
description = "AMI ID for EC2 instances (Ubuntu/AL2 etc)."
type = string
default     = "ami-0ecb62995f68bb549"  # Ubuntu 22.04 (us-east-1)
}




variable "asg_desired_capacity" {
type = number
default = 2
}


variable "asg_min_size" {
type = number
default = 1
}


variable "asg_max_size" {
type = number
default = 3
}



variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "alb-sg-2"
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "app_s3_bucket" {
  type = string
  default = "delight2026"
}


variable "app_s3_key" {
  type = string
  default = "app.zip"
}
