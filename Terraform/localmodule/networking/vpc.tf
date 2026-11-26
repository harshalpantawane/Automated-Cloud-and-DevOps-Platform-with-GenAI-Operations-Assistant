locals {
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  az_names              = data.aws_availability_zones.azs.names
}

# vpc
resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  # Runs on multi-tenant physical hardware. This is the standard, most cost-effective option for almost all workloads.
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "blackhat-${var.env_name}-project-vpc"
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  # count = Terraform loops that block 3 times.
  count = local.public_subnet_count

  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       =  local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "blackhat-${var.env_name}-pub-sub-${count.index + 1}"
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  # Create the specified number of public subnets defined in local variables
  count = local.private_subnet_count

  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = local.az_names[count.index]
  
  tags = {
    Name = "blackhat-${var.env_name}-pri-sub-${count.index + 1}"
  }
}

# project internet gateway
resource "aws_internet_gateway" "project_ig" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "blackhat-${var.env_name}-project-ig"
  }
}

# Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
}

# nat gateway
resource "aws_nat_gateway" "project_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id
  depends_on    = [aws_internet_gateway.project_ig]

  tags = {
    Name = "blackhat-${var.env_name}-nat-gateway"
  }
}

# public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = "blackhat-${var.env_name}-public-rt"
  }
}

# public route            
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_ig.id

}

# public subnet association
resource "aws_route_table_association" "public" {
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = "blackhat-${var.env_name}-private-rt"
  }
}

# private route
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.project_nat.id 
}

# private route association
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private_rt.id
  count          = local.private_subnet_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
}