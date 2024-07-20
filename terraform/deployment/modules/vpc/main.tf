resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "server-benchmarks-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "server-benchmarks-ig"
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)

  tags = {
    Name   = "server-benchmarks-public-subnet"
    Role   = "public"
    VPC    = aws_vpc.main.id
    Subnet = data.aws_availability_zones.available.names[count.index]
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count)

  tags = {
    Name   = "server-benchmarks-private-subnet"
    Role   = "private"
    VPC    = aws_vpc.main.id
    Subnet = data.aws_availability_zones.available.names[count.index]
  }
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "nat" {
  count = var.private_subnet_count

  domain = "vpc"

  tags = {
    Name = "server-benchmarks-eip"
    Role = "private"
    VPC  = aws_vpc.main.id
    Subnet = element(aws_subnet.public.*.id, count.index)
  }
}

resource "aws_nat_gateway" "ngw" {
  count = var.private_subnet_count

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "server-benchmarks-ngw"
    Role = "private"
    VPC  = aws_vpc.main.id
    Subnet = element(aws_subnet.public.*.id, count.index)
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "server-benchmarks-public-rt"
    Role = "public"
    VPC  = aws_vpc.main.id
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "server-benchmarks-private-rt"
    Role = "private"
    VPC  = aws_vpc.main.id
    Subnet = element(aws_subnet.private.*.id, count.index)
  }
}

resource "aws_route" "private" {
  count                  = var.private_subnet_count
  route_table_id = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count = var.private_subnet_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}