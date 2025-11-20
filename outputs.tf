output "hcp_terraform_organization" {
  value = {
    id   = data.tfe_organization.this.id
    name = data.tfe_organization.this.name
  }
  description = "Details about the tfe_organization resource."
}

output "hcp_terraform_organization_membership" {
  value       = data.tfe_organization_membership.this
  description = "The members (users) of the HCP Terraform Organization."
}

output "owners_team" {
  value = {
    id = data.tfe_team.owners.id
  }
  description = "The ID of the 'owners' team."
}

output "default_project" {
  value = {
    id = data.tfe_project.default.id
  }
  description = "The ID of the 'Default Project' project."
}

output "tfe_organization_configuration" {
  value       = var.tfe_organization
  description = "The inputs to the module."
}

output "module_path" {
  value       = path.module
  description = "The path to the module."
}
