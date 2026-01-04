resource "aws_lb_target_group" "alb-tg" {
  name        = "${var.name}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "alb-tg-attach" {
  for_each         = var.target_ids
  target_group_arn = aws_lb_target_group.alb-tg.arn
  port             = var.target_port
  target_id        = each.value
}