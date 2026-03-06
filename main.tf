terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region      = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "mio_server" {
  ami           = "ami-0c42fad2ea005202d"
  instance_type = "t3.micro"
  subnet_id = "subnet-0f51ae8ad5ebf787a"
  associate_public_ip_address = true 
}

# Restituisce l'IP pubblico dell'istanza per l'accesso SSH o Web
output "indirizzo_ip_pubblico" {
  description = "L'indirizzo IP pubblico assegnato al server"
  value       = aws_instance.mio_server.public_ip
}

# Restituisce l'ID dell'istanza (utile per debugging o comandi AWS CLI)
output "istanza_id" {
  description = "ID dell'istanza EC2"
  value       = aws_instance.mio_server.id
}
