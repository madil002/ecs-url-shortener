module "IdP" {
  source         = "./modules/IdP"
  aws_account_id = var.aws_account_id
}

module "VPC" {
  source  = "./modules/VPC"
  subnets = var.subnets
}

module "ECS" {
  source                  = "./modules/ECS"
  vpc_id                  = module.VPC.vpc_id
  private_subnets         = module.VPC.private_subnets
  aws_account_id          = var.aws_account_id
  container_image         = var.container_image
  ddb_table_name          = var.ddb_table_name
  ecs_task_ingress_sg_ids = [module.ALB.alb_sg_id]
  target_group_arn        = module.ALB.target_group_arn
  container_name          = "url-shortener"
  container_port          = "8080"
}

module "ALB" {
  source         = "./modules/ALB"
  public_subnets = module.VPC.public_subnets
  vpc_id         = module.VPC.vpc_id
}
