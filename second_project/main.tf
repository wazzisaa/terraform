terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 1. Modulo Rete
module "network" {
  source = "./modules/vpc"
}

# 2. Modulo Database
module "db" {
  source                = "./modules/database"
  db_password           = var.db_password
  subnet_ids            = module.network.private_subnets
  db_subnet_group_name  = module.network.db_subnet_group_name  # <--- Controlla questa riga
  vpc_id      = module.network.vpc_id
  # PASSAGGIO CHIAVE: Iniettiamo l'ID del firewall dell'EC2 nel DB
  web_sg_id            = module.web_server.web_sg_id
}

# 3. Modulo Compute
module "web_server" {
  source      = "./modules/compute"
  db_endpoint = module.db.rds_endpoint
  subnet_id   = module.network.public_subnet
  vpc_id      = module.network.vpc_id
}

#4. Modulo bucket S3
module "bucket" {
    source = "./modules/bucket"
}