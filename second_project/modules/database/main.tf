variable "db_password" { type = string }
variable "subnet_ids"  { type = list(string) }
variable "db_subnet_group_name" { type = string }
variable "web_sg_id" { type = string } # Variabile in ingresso dal modulo compute
variable "vpc_id"    { type = string } # Variabile in ingresso dal modulo vpc

resource "aws_security_group" "rds_sg" {
  name   = "rds-postgres-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.web_sg_id] # Permette l'accesso SOLO al Security Group dell'EC2
  }
}

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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}