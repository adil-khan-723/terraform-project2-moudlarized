variable "ami" {
  description = "ami of the instnaces"
  type        = string
}

variable "instance_type" {
  description = "type of the instance"
  type        = string
}

variable "key_name" {
  description = "name of the ssh key"
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "ids of the security groups to be attached to instances"
  type        = list(string)
}

variable "instances" {
  type        = map(string)
  description = "maps the instance name to the subnet id"

}