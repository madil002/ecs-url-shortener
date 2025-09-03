resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags             = { Name = "Main" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "Main-igw" }
}

resource "aws_subnet" "all" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = { Name = each.key }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Main-public-rt" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "Main-private-rt" }
}

resource "aws_route_table_association" "all" {
  for_each = var.subnets

  subnet_id      = aws_subnet.all[each.key].id
  route_table_id = each.value.type == "public" ? aws_route_table.public.id : aws_route_table.private.id
}
