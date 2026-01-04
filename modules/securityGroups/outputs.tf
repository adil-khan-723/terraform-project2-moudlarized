output "id" {
  value       = aws_security_group.sg.id
  description = "id for the security group"
}

output "arn" {
  value       = aws_security_group.sg.arn
  description = "arn for the security group"
}