resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags       = { Name = "Main DB Subnet Group" }
}

# OUTPUT: Questi servono al main.tf per passare i dati agli altri moduli
output "public_subnet" { value = aws_subnet.subnet_a.id }
output "private_subnets" { value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id] }
output "db_subnet_group_name" { value = aws_db_subnet_group.main.name }
output "vpc_id" {
  description = "L'ID della VPC creata"
  value       = aws_vpc.main.id
}