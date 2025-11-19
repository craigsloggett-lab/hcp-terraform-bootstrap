output "hcp_terraform_organization_name" {
  value       = data.tfe_organization.this.name
  description = "The name of the HCP Terraform Organization."
}

output "hcp_terraform_organization_membership" {
  value       = data.tfe_organization_membership.this
  description = "The members (users) of the HCP Terraform Organization."
}

output "owners_team_id" {
  value       = data.tfe_team.owners.id
  description = "The ID of the 'owners' team."
}

output "default_project_id" {
  value       = data.tfe_project.default.id
  description = "The ID of the 'Default Project' project."
}
