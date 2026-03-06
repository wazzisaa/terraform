variable "db_password" { type = string }
variable "subnet_ids"  { type = list(string) }

resource "aws_db_subnet_group" "postgres_group" {
  name       = "media-backend-db-group"
  subnet_ids = var.subnet_ids # Qui colleghiamo le tue subnet reali

  tags = {
    Name = "Postgres DB Subnet Group"
  }
}


resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "freedb"
  username             = "dbadmin"
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.postgres_group.name
  depends_on = [aws_db_subnet_group.postgres_group]
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}