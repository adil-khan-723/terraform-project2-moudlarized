output "dns" {
  description = "dns name for the alb"
  value       = module.alb.alb_dns_name
}

output "hello" {
  description = "hello"
  value       = "hello"
}