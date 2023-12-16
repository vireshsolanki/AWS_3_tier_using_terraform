resource "aws_lb" "alb-internal" {
    name = "${var.project-name}-internal-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.alb-internal-sg-id]
    subnets = [var.private-3-1a-id, var.private-4-1b-id]
    enable_deletion_protection = false
    tags = {
      Name = "${var.project-name}-internal-alb"
    }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = "${var.project-name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id
   health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.alb-internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}



