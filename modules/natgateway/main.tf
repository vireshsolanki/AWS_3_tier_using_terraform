resource "aws_eip" "eip-natgw-a" {
    vpc = true
    tags = {
      Name = "eip-natgw-a"
    }
}

resource "aws_eip" "eip-natgw-b" {
    vpc = true
    tags = {
      Name = "eip-natgw-b"
    }
}
  
resource "aws_nat_gateway" "nat-gw-a" {
  allocation_id = aws_eip.eip-natgw-a.id
  subnet_id     = var.public-1-1a-id

  tags = {
    Name = "nat-gw-a"
  }

  depends_on = [var.igw-id]
}
 
resource "aws_nat_gateway" "nat-gw-b" {
  allocation_id = aws_eip.eip-natgw-b.id
  subnet_id     = var.public-2-1b-id

  tags = {
    Name = "nat-gw-b"
  }

  depends_on = [var.igw-id]
}

resource "aws_route_table" "private-rt" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-a.id
  }


  tags = {
    Name = "private-rt"
  }
}
resource "aws_route_table_association" "private-3-1a-association" {
  subnet_id      = var.private-3-1a-id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "private-4-1b-association" {
  subnet_id      = var.private-4-1b-id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table" "db-rt" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-b.id
  }

  tags = {
    Name = "db-rt"
  }
}
resource "aws_route_table_association" "db-5-1a-association" {
  subnet_id      = var.db-5-1a-id
  route_table_id = aws_route_table.db-rt.id
}
resource "aws_route_table_association" "db-6-1b-association" {
  subnet_id      = var.db-6-1b-id
  route_table_id = aws_route_table.db-rt.id
}
