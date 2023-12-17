data "aws_acm_certificate" "issued" {
  domain   = var.certificate-dn
  statuses = ["ISSUED"]
}

resource "aws_lb" "alb-internet" {
    name = "${var.project-name}-internet-alb"
    internal = true
    load_balancer_type = "application"
    security_groups = [var.alb-internet-sg-id]
    subnets = [var.public-1-1a-id, var.public-2-1b-id]
    enable_deletion_protection = false
    tags = {
      Name = "${var.project-name}-internal-alb"
    }
}

resource "aws_lb_target_group" "alb-internet-tg" {
  name     = "${var.project-name}-alb-internet-tg"
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
resource "aws_lb_listener" "alb-listner" {
  load_balancer_arn = aws_lb.alb-internet.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-internet-tg.arn
  }
}

