output "alb-internal-dns" {
    value = aws_lb.alb-internal.dns_name
}
output "tg-arn" {
    value = aws_lb_target_group.alb-tg.arn
}
