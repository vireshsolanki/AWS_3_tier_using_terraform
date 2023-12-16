output "cloudfront-dns" {
    value = aws_cloudfront_distribution.my_distribution.domain_name 
}
output "cloudfront-id" {
    value = aws_cloudfront_distribution.my_distribution.id
}
output "cloudfront-arn" {
    value = aws_cloudfront_distribution.my_distribution.arn 
}
output "cloudfront-status" {
    value = aws_cloudfront_distribution.my_distribution.status
}
output "cloudfront-hosted-zone-id" {
    value = aws_cloudfront_distribution.my_distribution.hosted_zone_id
  
}