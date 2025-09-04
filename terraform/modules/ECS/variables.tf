variable "aws_account_id" {
  type = string
}

variable "container_image" {
  type = string
}

variable "ddb_table_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}
