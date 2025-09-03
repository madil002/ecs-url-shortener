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

variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    cidr : string
    az : string
    type : string
  }))
  default = {
    public_a  = { cidr = "10.0.1.0/24", az = "eu-west-2a", type = "public" }
    private_a = { cidr = "10.0.2.0/24", az = "eu-west-2a", type = "private" }
    public_b  = { cidr = "10.0.3.0/24", az = "eu-west-2b", type = "public" }
    private_b = { cidr = "10.0.4.0/24", az = "eu-west-2b", type = "private" }
  }
}
