output "vpc_id" {
  value = aws_vpc.project_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.project_vpc.cidr_block
}
output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}