variable "db_endpoint" { type = string }
variable "subnet_id"   { type = string }

resource "aws_instance" "web" {
  ami           = "ami-0faab6414a6e30064" # Amazon Linux 2023 in eu-central-1
  instance_type = "t2.micro"             # Free Tier
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              echo "DATABASE_URL=${var.db_endpoint}" >> /etc/environment
              EOF

  tags = { Name = "EC2-Free-Tier" }
}