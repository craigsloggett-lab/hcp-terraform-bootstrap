output "hcp_terraform_organization_name" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization_name
  description = "The name of the HCP Terraform Organization."
}

output "hcp_terraform_organization_membership" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization_membership
  description = "The members (users) of the HCP Terraform Organization."
}

output "owners_team_id" {
  value       = module.terraform_tfe_bootstrap.owners_team_id
  description = "The ID of the 'owners' team."
}

output "default_project_id" {
  value       = module.terraform_tfe_bootstrap.default_project_id
  description = "The ID of the 'Default Project' project."
}
