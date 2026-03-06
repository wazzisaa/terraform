variable "db_endpoint" { type = string }
variable "subnet_id"   { type = string }

resource "aws_instance" "web" {
  ami           = "ami-0c42fad2ea005202d"
  instance_type = "t3.micro"             # Free Tier
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              echo "DATABASE_URL=${var.db_endpoint}" >> /etc/environment
              EOF

  tags = { Name = "EC2-Free-Tier" }
}