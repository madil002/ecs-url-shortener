terraform {
  backend "s3" {
    bucket       = "terraform-state-adil"
    key          = "ecs2-url-shortener"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
