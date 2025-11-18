output "hcp_terraform_organization_name" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization_name
  description = "The name of the HCP Terraform Organization."
}

output "hcp_terraform_organization_membership" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization_membership
  description = "A map of user details for members in the HCP Terraform Organization."
}

output "default_project_id" {
  value       = module.terraform_tfe_bootstrap.default_project_id
  description = "The ID of the Default Project."
}
