output "tfe_organizations" {
  value = {
    this = {
      id   = data.tfe_organization.this.id
      name = data.tfe_organization.this.name
    }
  }
  description = "A map of the HCP Terraform organizations details including 'id' and 'name'. Only inludes 'this' organization."
}

output "tfe_organization_memberships" {
  value       = data.tfe_organization_membership.this
  description = "A map of the HCP Terraform organization members, intended to be iterated over to discover users."
}

output "tfe_teams" {
  value = {
    owners = {
      id = data.tfe_team.owners.id
    }
  }
  description = "A map of the HCP Terraform teams with their 'id' as the only key. Only includes the 'owners' team."
}

output "tfe_projects" {
  value = {
    default = {
      id = data.tfe_project.default.id
    }
  }
  description = "A map of the HCP Terraform projects with their 'id' as the only key. Only includes the 'Default Project' project."
}
