output "alb_dns_name" {
  description = "dns name of the alb"
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "arn of the alb"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "target group arn"
  value       = aws_lb_target_group.alb-tg.arn
}