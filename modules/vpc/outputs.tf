output "region" {
  value = var.region
}
output "project-name" {
    value = var.project-name
}
output "vpc-id" {
    value = aws_vpc.vpc.id
}
output "igw-id" {
    value = aws_internet_gateway.igw.id
}
output "public-1-1a-id" {
  value = aws_subnet.public-1-1a.id
}
output "public-2-1b-id" {
  value = aws_subnet.public-2-1b.id
}
output "private-3-1a-id" {
  value = aws_subnet.private-3-1a.id
}
output "private-4-1b-id" {
  value = aws_subnet.private-4-1b.id
}
output "db-5-1a-id" {
  value = aws_subnet.db-5-1a.id
}
output "db-6-1a-id" {
  value = aws_subnet.db-6-1b.id
}