variable "db_password" { type = string }
variable "subnet_ids"  { type = list(string) }

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "freedb"
  username             = "dbadmin"
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = false
  subnet_id     = var.subnet_id

}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}