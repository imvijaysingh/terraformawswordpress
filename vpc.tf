resource "aws_vpc" "main" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    "Name" = "wp-sql"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  tags = {
    "Name" = "${"wp-sql"}-public"
  }
}

resource "aws_subnet" "private" {
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${"wp-sql"}-private"
  }
}

resource "aws_internet_gateway" "aigateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${"wp-sql"}-inbound"
  }
}

resource "aws_eip" "nating" {
  tags = {
    "Name" = "${"wp-sql"}-eip-nating"
  }
}

resource "aws_nat_gateway" "aigateway" {
  allocation_id = aws_eip.nating.id
  subnet_id     = aws_subnet.public.id
  tags = {
    "Name" = "${"wp-sql"}-nating"
  }
}

resource "aws_route_table" "secondary_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aigateway.id
  }
  tags = {
    "Name" = "custom-inbound-table"
  }
}

resource "aws_route_table_association" "public_custom" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.secondary_table.id
}

resource "aws_default_route_table" "main_table" {
  default_route_table_id = aws_vpc.main.main_route_table_id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.aigateway.id
  }
  tags = {
    "Name" = "main-nating-table"
  }
}

resource "aws_route_table_association" "private_custom" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_default_route_table.main_table.id
}

