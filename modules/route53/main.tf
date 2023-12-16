data "aws_route53_zone" "public-zone" {
  name         = var.hosted-zone-name
  private_zone = false
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = data.aws_route53_zone.public-zone.zone_id
  name    = "week3.${data.aws_route53_zone.public-zone.name}"
  type    = "A"

  alias {
    name                   = var.cloudfront-dns
    zone_id                = var.cloudfront-hosted-zone-id
    evaluate_target_health = false
  }
}
