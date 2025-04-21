resource "aws_vpc" "bg_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "bg_vpc_vpc_r"
  }
}

resource "aws_subnet" "bg_subnet" {
  vpc_id                  = aws_vpc.bg_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "bg_subnet_2" {
  vpc_id                  = aws_vpc.bg_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "bg_igw" {
  vpc_id = aws_vpc.bg_vpc.id
  tags = {
    Name = "bg_igw"
  }
}

resource "aws_route_table" "bg_rt" {
  vpc_id = aws_vpc.bg_vpc.id
  tags = {
    Name = "bg_rt"
  }
}

resource "aws_route" "bg_default" {
  route_table_id         = aws_route_table.bg_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bg_igw.id
}

resource "aws_route_table_association" "bg_rta" {
  subnet_id      = aws_subnet.bg_subnet.id
  route_table_id = aws_route_table.bg_rt.id
}

resource "aws_security_group" "bg_web_sg" {
  vpc_id = aws_vpc.bg_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bg_web_sg"
  }
}
