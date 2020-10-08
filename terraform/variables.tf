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

variable "node_instance_type" {
  description = ""
  default     = "i3.2xlarge"
}

variable "nodes_count" {
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
    22,     # ssh
    8080,   # crdb dashboard + metrics
    9090,   # prometheus dashboard
    9100,   # node_exporter
    26257,  # crdb internal
  ]
}

variable "node_ports" {
  description = ""
  type        = list(number)
  default = [
    8080,   # crdb dashboard + metrics
    9100,   # node_exporter
    26257   # crdb internal
  ]
}

variable "lb_target_port" {
  default = 26257
}

variable "loaders" {
  description = "number of loaders nodes to allocate"
  default = 0
}

variable "loaders_instance_type" {
  default = "c5.xlarge"
}

variable "loaders_ami" {
  description = "Amazon Linux 2 AMI 2.0.20200917.0 x86_64 HVM gp2"
  default = "ami-0653812935d0743fe"
}

variable "node_ami" {
  description = "Amazon Linux 2 AMI 2.0.20200917.0 x86_64 HVM gp2"
  default = "ami-0653812935d0743fe"
}

variable "monitor" {
  default = 0
}

variable "monitor_instance_type" {
  default = "t3.large"
}

variable "monitor_ami" {
  description = "Amazon Linux 2 AMI 2.0.20200917.0 x86_64 HVM gp2"
  default = "ami-0653812935d0743fe"
}

variable "user_tags" {
  description = "User defined tags"
  type = map(string)
  default = {}
}