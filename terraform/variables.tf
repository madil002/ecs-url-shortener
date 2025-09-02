variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "container_image" {
  type      = string
  sensitive = true
}

variable "ddb_table_name" {
  type = string
}
