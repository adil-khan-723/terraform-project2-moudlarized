variable "name" {
  description = "name of the security group"
  type        = string
}

variable "description" {
  description = "description of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "contents of the ingress rules"
  type = map(object({
    from_port                    = number
    to_port                      = number
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    ip_protocol                  = string
  }))
  default = {}
}

variable "egress_rules" {
  description = "contents of the egress rules"
  type = map(object({
    cidr_ipv4   = string
    ip_protocol = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = {}
}

variable "vpc_id" {
  description = "vpc id where the sg will be created"
  type        = string
}

variable "tags" {
  description = "tags for the sg"
  type        = map(string)
  default     = {}
}