variable "db_password" { type = string }
variable "subnet_ids"  { type = list(string) }
variable "db_subnet_group_name" { type = string }

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro" # Free Tier
  db_name              = "freedb"
  username             = "dbadmin"
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = var.db_subnet_group_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}