resource "aws_lb" "main" {
  name                       = "ALB"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "Blue" {
  name        = "Blue"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/healthz"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "Green" {
  name        = "Green"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/healthz"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Blue.arn
  }

}

resource "aws_security_group" "alb_sg" {
  name        = "alb"
  vpc_id      = var.vpc_id
  description = "SG for ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
