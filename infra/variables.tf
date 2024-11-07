variable "bucket_name" {
	type = string
}

variable "s3_data_path" {
  description = "Caminho dos dados no s3"
  type = string
}

variable "glue_database_name" {
  description = "Nome do banco de dados Glue"
  type = string
}