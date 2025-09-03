module "IdP" {
  source         = "./modules/IdP"
  aws_account_id = var.aws_account_id
}

module "VPC" {
  source  = "./modules/VPC"
  subnets = var.subnets
}
