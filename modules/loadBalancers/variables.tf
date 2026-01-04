variable "name" {
  description = "name of the loadbalancer"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnet_ids" {
  description = "ids of the subnet in which alb should operate"
  type        = list(string)
}

variable "security_group_id" {
  description = "id of the security group for the alb"
  type        = string
}

variable "target_ids" {
  description = "target instances to be registered to the target group"
  type        = map(string)
}

variable "listener_port" {
  description = "port on which alb listens"
  type        = number
  default     = 80
}

variable "target_port" {
  description = "target group port"
  type        = number
  default     = 80
}
variable "tags" {
  description = "Tags for ALB resources"
  type        = map(string)
  default     = {}
}
variable "deletion" {
  type        = bool
  description = "deletion protection for the alb"
  default     = false
}