# data "aws_vpc" "existing_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = [var.name]
#   }
#   filter {
#     name   = "cidr-block-association.cidr-block"
#     values = [var.vpc_cidr_block]
#   }
# }

resource "aws_vpc" "new_vpc" {
  # count = data.aws_vpc.existing_vpc ? 0 : 1
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "${element(var.public_subnets,   count.index)}"  # Adjust the CIDR block as per your requirement
  availability_zone       = element(var.azs,count.index)
  tags = {
    Name = "${var.name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "${element(var.private_subnets,   count.index)}"  # Adjust the CIDR block as per your requirement
  availability_zone       = element(var.azs,count.index)
  tags = {
    Name = "${var.name}-private-subnets-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.name}-publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
  tags = {
    Name = "${var.name}-ip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, 0)
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.name}-ng"
  }
  
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.name}-pvtrt"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private_subnets.*.id,count.index)
}