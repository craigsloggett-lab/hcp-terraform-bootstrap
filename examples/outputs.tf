output "hcp_terraform_organization" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization
  description = "Details about the tfe_organization resource."
}

output "default_project_id" {
  value       = module.terraform_tfe_bootstrap.default_project_id
  description = "Details about the tfe_organization resource."
}
