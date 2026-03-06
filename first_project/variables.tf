variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type      = string
  sensitive = true # Evita che il valore appaia nei log della CLI
}
