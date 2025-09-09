plugin "terraform" {
  enabled = true
  preset  = "all"
}

config {
  call_module_type = "all"
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}
