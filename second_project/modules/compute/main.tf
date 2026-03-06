variable "db_endpoint" { type = string }
variable "subnet_id"   { type = string }

resource "aws_instance" "web" {
  ami           = "ami-0faab6414a6e30064"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              echo "DATABASE_URL=${var.db_endpoint}" >> /etc/environment
              EOF

  tags = { Name = "Modular-EC2-FreeTier" }
}