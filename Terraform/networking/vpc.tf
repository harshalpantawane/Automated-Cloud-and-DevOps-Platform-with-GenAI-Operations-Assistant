locals {
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  az_names              = data.aws_availibility_zones.azs.name
}
resource "aws_vpc" "poject_vpc" {
  cidr_block           = var.vpc_cidr
  # Runs on multi-tenant physical hardware. This is the standard, most cost-effective option for almost all workloads.
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_name}-project-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  # count = Terraform loops that block 3 times.
  count = local.public_subnet_count

  vpc_id                  = aws_vpc.poject_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       =  local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-pub-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  # Create the specified number of public subnets defined in local variables
  count = local.private_subnet_count

  vpc_id = aws_vpc.project_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = local.az_names[count.index]
  
  tags = {
    Name = "${var.env_name}-pri-sub-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "proj_ig" {
  vpc_id = aws_vpc.poject_vpc.id

  tags = {
    Name = "${var.env_name}-project-ig"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "proj-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet[0].id
  depends_on = [aws_internet_gateway.proj_ig]

  tags = {
    Name = "${var.env_name}-nat-gatewy"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.poject_vpc.id
  tags = {
    Name = "${var.env_name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.proj_ig.id

}

resource "aws_route_table_association" "pub-rt-asso" {
  count = local.public_subnet_count
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.poject_vpc.id
  tags = {
    Name = "${var.env_name}-private-rt"
  }
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_rt
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.proj-nat.id 
}

resource "aws_route_table_association" "pri-rt-asso" {
  route_table_id = aws_route_table.private_rt.id
  count = local.private_subnet_count
  subnet_id = aws_subnet.private_subnet[count.index].id
}