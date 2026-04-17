variable "db_user" {
  description = "Usuario de la base de datos PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Contraseña de la base de datos PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
  default     = "lab_db"
}