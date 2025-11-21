output "tfe_organizations" {
  value = {
    this = {
      id   = data.tfe_organization.this.id
      name = data.tfe_organization.this.name
    }
  }
  description = "."
}

output "tfe_organization_memberships" {
  value       = data.tfe_organization_membership.this
  description = "."
}

output "tfe_teams" {
  value = {
    owners = {
      id = data.tfe_team.owners.id
    }
  }
  description = "The ID of the 'owners' team."
}

output "tfe_projects" {
  value = {
    default = {
      id = data.tfe_project.default.id
    }
  }
  description = "The ID of the 'Default Project' project."
}
