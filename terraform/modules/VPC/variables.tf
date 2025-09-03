variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    cidr : string
    az : string
    type : string
  }))
}
