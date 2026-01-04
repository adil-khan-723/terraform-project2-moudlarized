output "instance_ids" {
  description = "instance ids"
  value = {
    for k, v in aws_instance.ec2 :
    k => v.id
  }
}

output "instance_private_ips" {
  description = "private ips of each instance"
  value = {
    for k, v in aws_instance.ec2 :
    k => v.private_ip
  }
}

output "instance_arns" {
  description = "arn of the instances"
  value = {
    for k, v in aws_instance.ec2 :
    k => v.arn
  }
}