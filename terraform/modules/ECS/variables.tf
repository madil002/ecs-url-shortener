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

variable "ecs_task_ingress_sg_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = string
}
