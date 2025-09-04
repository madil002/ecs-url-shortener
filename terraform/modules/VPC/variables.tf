variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    cidr : string
    az : string
    type : string
  }))
}

variable "endpoints" {
  type = object({
    Interface : map(string)
    Gateway : map(string)
  })

  default = {
    Interface = {
      ecr_api = "com.amazonaws.eu-west-2.ecr.api"
      ecr_dkr = "com.amazonaws.eu-west-2.ecr.dkr"
    }
    Gateway = {
      s3  = "com.amazonaws.eu-west-2.s3"
      ddb = "com.amazonaws.eu-west-2.dynamodb"
    }
  }
}
