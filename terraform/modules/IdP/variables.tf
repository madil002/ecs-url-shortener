variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}
