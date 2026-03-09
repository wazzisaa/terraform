variable "db_endpoint" { type = string }
variable "subnet_id"   { type = string }
variable "vpc_id" { type = string } # Variabile in ingresso dal modulo VPC

resource "aws_security_group" "web_sg" {
  name   = "ec2-web-sg"
  vpc_id = var.vpc_id

# AGGIUNGI QUESTO PER ENTRARE NELLA MACCHINA
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In produzione metteresti solo il tuo IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  ami           = "ami-0c42fad2ea005202d"
  instance_type = "t3.micro"             # Free Tier
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "DATABASE_URL=${var.db_endpoint}" >> /etc/environment
              EOF

  tags = { Name = "EC2-Free-Tier" }
}

# ESPONI L'ID per il modulo database
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}