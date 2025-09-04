module "IdP" {
  source         = "./modules/IdP"
  aws_account_id = var.aws_account_id
}

module "VPC" {
  source  = "./modules/VPC"
  subnets = var.subnets
}

module "ECS" {
  source          = "./modules/ECS"
  vpc_id          = module.VPC.vpc_id
  private_subnets = module.VPC.private_subnets
  aws_account_id  = var.aws_account_id
  container_image = var.container_image
  ddb_table_name  = var.ddb_table_name
}
