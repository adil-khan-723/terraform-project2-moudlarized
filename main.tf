locals {
  instances = {
    for i in range(var.instance_count) :
    "instance-${i + 1}" => data.aws_subnets.default_subnets.ids[i % length(data.aws_subnets.default_subnets.ids)]
  }
}

module "vms_sg" {
  source      = "./modules/securityGroups"
  name        = "vm-sg"
  description = "security group for the vms"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = {
    http = {
      from_port                    = var.http
      to_port                      = var.http
      ip_protocol                  = var.ip_protocol
      referenced_security_group_id = module.alb_sg.id
    }
    ssh = {
      from_port   = var.ssh
      to_port     = var.ssh
      cidr_ipv4   = var.cidr_ssh
      ip_protocol = var.ip_protocol
    }
  }
  egress_rules = {
    all = {
      cidr_ipv4   = var.cidr_all
      ip_protocol = "-1"
    }
  }
}

module "alb_sg" {
  source      = "./modules/securityGroups"
  name        = "alb_sg"
  description = "security group for the alb"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = {
    http = {
      from_port   = var.http
      to_port     = var.http
      ip_protocol = var.ip_protocol
      cidr_ipv4   = var.cidr_http
    }
  }
  egress_rules = {
    all = {
      cidr_ipv4   = var.cidr_all
      ip_protocol = "-1"
    }
  }

}

module "ec2" {
  source             = "./modules/instances"
  ami                = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_ids = [module.vms_sg.id]
  tags = {
    "Project" = "terraform-modules"
  }
  instances = local.instances
}

module "alb" {
  source            = "./modules/loadBalancers"
  name              = "alb"
  security_group_id = module.alb_sg.id
  subnet_ids        = data.aws_subnets.default_subnets.ids
  deletion          = false
  tags = {
    "Project" = "terraform-modules"
  }
  listener_port = 80
  target_port   = 80
  vpc_id        = data.aws_vpc.default.id
  target_ids    = module.ec2.instance_ids
}


