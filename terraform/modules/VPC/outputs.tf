output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [
    for key, subnet in aws_subnet.all : subnet.id
    if var.subnets[key].type == "public"
  ]
}

output "private_subnets" {
  value = [
    for key, subnet in aws_subnet.all : subnet.id
    if var.subnets[key].type == "private"
  ]
}
