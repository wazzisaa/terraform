resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# RDS richiede subnet in almeno due zone diverse
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

# Creazione del DB Subnet Group obbligatorio per RDS
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = { Name = "Main DB Subnet Group" }
}

output "public_subnet" { value = aws_subnet.subnet_a.id }
output "private_subnets" { value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id] }
output "db_subnet_group_name" { value = aws_db_subnet_group.main.name }

}