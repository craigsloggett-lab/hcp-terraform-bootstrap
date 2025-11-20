output "hcp_terraform_organization" {
  value = {
    id   = module.terraform_tfe_bootstrap.hcp_terraform_organization.id
    name = module.terraform_tfe_bootstrap.hcp_terraform_organization.name
  }
  description = "Details about the tfe_organization resource."
}

output "hcp_terraform_organization_inputs" {
  value       = module.terraform_tfe_bootstrap.hcp_terraform_organization_inputs
  description = "The input paramters for the HCP Terraform organization configuration."
}
