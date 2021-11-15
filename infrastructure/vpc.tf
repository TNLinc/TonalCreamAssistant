resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  tags                 = merge(var.tags, { Name = "${var.app_name}-vpc" }, )
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.app_name}-public-subnet-1" }, )
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.app_name}-public-subnet-2" }, )
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = merge(var.tags, { Name = "${var.app_name}-private-subnet-1" }, )
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = merge(var.tags, { Name = "${var.app_name}-private-subnet-2" }, )
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, { Name = "${var.app_name}-route-table" }, )
}

resource "aws_security_group" "allow_web" {
  name        = "${var.app_name}-web-traffic"
  description = "Allow Web traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.app_name}-allow-web" }, )
}
