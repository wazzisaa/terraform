variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type      = string
  sensitive = true # Evita che il valore appaia nei log della CLI
}

variable "db_password" {
  type      = string
  sensitive = true
}