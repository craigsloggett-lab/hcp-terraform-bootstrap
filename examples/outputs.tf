output "tfe_organization_configuration" {
  value       = module.terraform_tfe_bootstrap.tfe_organization_configuration
  description = "The configuration for the HCP Terraform organization."
}

output "module_path" {
  value       = module.terraform_tfe_bootstrap.module_path
  description = "The path to the module."
}
