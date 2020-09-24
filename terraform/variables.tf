variable "aws_access_key" {
  description = ""
  default     = ""
}

variable "aws_secret_key" {
  description = ""
  default     = ""
}

variable "aws_region" {
  description = ""
  default     = "eu-north-1"
}

variable "aws_instance_type" {
  description = ""
  default     = "i3.2xlarge"
}

variable "cluster_count" {
  description = ""
  default     = 3
}

variable "cluster_user_cidr" {
  description = ""
  type        = list(string)
  default     = []
}

variable "cluster_broadcast" {
  description = ""
  default     = "public"
}

variable "environment" {
  description = ""
  default     = "development"
}

variable "module_version" {
  description = ""
  default     = "0.0.1"
}

variable "owner" {
  description = ""
  default     = "terraform"
}

variable "user_ports" {
  description = ""
  type        = list(number)
  default = [
    22,
    8080,
    26257
  ]
}

variable "node_ports" {
  description = ""
  type        = list(number)
  default = [
    26257
  ]
}

variable "aws_ami" {
  description = "Amazon Linux 2 AMI 2.0.20200917.0 x86_64 HVM gp2"
  default = "ami-0653812935d0743fe"
}

