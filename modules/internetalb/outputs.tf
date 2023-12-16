output "alb-internet-dns" {
    value = aws_lb.alb-internet.dns_name
}
output "tg-internet-arn" {
    value = aws_lb_target_group.alb-internet-tg.arn
}
output "certificate-dns" {
    value = data.aws_acm_certificate.issued.arn
  
}