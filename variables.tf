variable "instance_count" {
  description = "no. of instances to be launched"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "instance type to be launched"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "name of the key to be attached to the instances"
  type        = string
}

variable "http" {
  description = "http port"
  type        = number
}

variable "ssh" {
  description = "ssh port"
  type        = number
}

variable "cidr_http" {
  description = "cidr block for the http tarffic flow"
  type        = string
}

variable "cidr_ssh" {
  description = "cidr block for the ssh traffic flow"
  type        = string
}

variable "ip_protocol" {
  description = "protocol"
  type        = string
}

variable "cidr_all" {
  description = "cidr block for egress rule"
  type        = string
}