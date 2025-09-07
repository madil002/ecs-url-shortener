output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_blue_arn" {
  value = aws_lb_target_group.Blue.arn
}

output "lb_arn" {
  value = aws_lb.main.arn
}

output "target_group_blue_name" {
  value = aws_lb_target_group.Blue.name
}

output "target_group_green_name" {
  value = aws_lb_target_group.Green.name
}

output "listener_http_arn" {
  value = aws_lb_listener.http.arn
}
