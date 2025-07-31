#------------------------------
# VPC
#------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# -------------------------
# Public Subnet
# -------------------------
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-${element(var.availability_zones, count.index)}"
    Project = var.project
    Env     = var.environment
    type    = "public"
  }
}

# ------------------------------
# Private Subnets
# ------------------------------
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-${element(var.availability_zones, count.index)}"
    Project = var.project
    Env     = var.environment
    type    = "private"
  }
}

# ------------------------------
# Isolated Subnets
# ------------------------------
resource "aws_subnet" "isolated_subnet" {
  count                   = length(var.isolated_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.isolated_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-isolated-subnet-${element(var.availability_zones, count.index)}"
    Project = var.project
    Env     = var.environment
    type    = "private"
  }
}

# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    type    = "public"
  }
}
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}


# ------------------------------
# Private Route Tables
# ------------------------------
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw[count.index].id
  }

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt-${element(var.availability_zones, count.index)}"
    Project = var.project
    Env     = var.environment
    type    = "private"
  }
}
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = aws_route_table.private_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

# ------------------------------
# Isolated Route Table
# ------------------------------
resource "aws_route_table" "isolated_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-isolated-rt"
    Project = var.project
    Env     = var.environment
    type    = "private"
  }
}
resource "aws_route_table_association" "isolated_rt_assoc" {
  count          = length(aws_subnet.isolated_subnet)
  subnet_id      = aws_subnet.isolated_subnet[count.index].id
  route_table_id = aws_route_table.isolated_rt.id
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

# -------------------------
# Elastic IPs for NAT Gateway
# -------------------------
resource "aws_eip" "eip_nat" {
  count  = length(var.availability_zones)

  tags = {
    Name = "${var.project}-${var.environment}-eip-nat-${element(var.availability_zones, count.index)}"
  }
}


# -------------------------
# NAT Gateway
# -------------------------
resource "aws_nat_gateway" "natgw" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.eip_nat[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name    = "${var.project}-${var.environment}-natgw-${element(var.availability_zones, count.index)}"
    Project = var.project
    Env     = var.environment
  }

  depends_on = [aws_internet_gateway.igw]
}