output "vpc_id" {
  value = aws_vpc.poject_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.poject_vpc.cidr_block
}
output "public_subent_ids" {
  value = [for subnet in aws_aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_aws_subnet.private_subnet : subnet.id]
}