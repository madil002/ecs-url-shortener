variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "listener_http_arn" {
  type = string
}

variable "target_group_blue_name" {
  type = string
}

variable "target_group_green_name" {
  type = string
}
