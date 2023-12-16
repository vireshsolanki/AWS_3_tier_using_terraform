resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project-name}-vpc"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project-name}-igw"
  }
}
data "aws_availability_zones" "available" {
}
resource "aws_subnet" "public-1-1a" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  cidr_block = var.public-1-1a-cidr

  tags = {
    Name = "public-1-1a"
  }
}
resource "aws_subnet" "public-2-1b" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  cidr_block = var.public-2-1b-cidr

  tags = {
    Name = "public-2-1b"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public-1-1a-asscoiation" {
  subnet_id      = aws_subnet.public-1-1a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-2-1b-asscoiation" {
  subnet_id      = aws_subnet.public-2-1b.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_subnet" "private-3-1a" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  cidr_block = var.private-3-1a-cidr

  tags = {
    Name = "private-3-1a"
  }
}

resource "aws_subnet" "private-4-1b" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  cidr_block = var.private-4-1b-cidr

  tags = {
    Name = "private-4-1b"
  }
}

resource "aws_subnet" "db-5-1a" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  cidr_block = var.db-5-1a-cidr

  tags = {
    Name = "db-5-1a"
  }
}

resource "aws_subnet" "db-6-1b" {
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  cidr_block = var.db-6-1b-cidr

  tags = {
    Name = "db-6-1b"
  }
}