module "IdP" {
  source         = "./modules/IdP"
  aws_account_id = var.aws_account_id
}

locals {
  subnets = {
    public_a  = { cidr = "10.0.1.0/24", az = "eu-west-2a", type = "public" }
    private_a = { cidr = "10.0.2.0/24", az = "eu-west-2a", type = "private" }
    public_b  = { cidr = "10.0.3.0/24", az = "eu-west-2b", type = "public" }
    private_b = { cidr = "10.0.4.0/24", az = "eu-west-2b", type = "private" }
  }
}

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
  for_each = local.subnets

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
  for_each = local.subnets

  subnet_id      = aws_subnet.all[each.key].id
  route_table_id = each.value.type == "public" ? aws_route_table.public.id : aws_route_table.private.id
}
