resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "main-vpc" }
}

# 1. IL PONTE: Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-igw" }
}

# 2. LA SUBNET PUBBLICA (Modificata per IP Pubblico)
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  # AGGIUNGI QUESTO: fondamentale per EC2 Instance Connect!
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet" }
}

# 3. LA SUBNET PRIVATA (Per il DB)
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
  tags              = { Name = "private-subnet" }
}

# 4. LA TABELLA DI ROUTING: Dice alla subnet_a come andare su internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "public-route-table" }
}

# 5. IL COLLEGAMENTO: Associa la tabella alla Subnet A
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags       = { Name = "Main DB Subnet Group" }
}

# --- OUTPUT (Invariati) ---
output "public_subnet" { value = aws_subnet.subnet_a.id }
output "private_subnets" { value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id] }
output "db_subnet_group_name" { value = aws_db_subnet_group.main.name }
output "vpc_id" {
  description = "L'ID della VPC creata"
  value       = aws_vpc.main.id
}