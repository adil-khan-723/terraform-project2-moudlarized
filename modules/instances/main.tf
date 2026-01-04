resource "aws_instance" "ec2" {
  for_each               = var.instances
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = each.value
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  user_data = templatefile("${path.module}/user_data.tpl", {
    instance_name = each.key
  })

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


