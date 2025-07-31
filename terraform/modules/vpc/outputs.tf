output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "isolated_subnet_ids" {
  value = aws_subnet.isolated_subnet[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.natgw[*].id
}
