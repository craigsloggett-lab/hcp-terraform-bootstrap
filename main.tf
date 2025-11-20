# These are expected to be imported by the consuming root module as showcased in the examples/ directory.

resource "tfe_organization" "this" {
  name  = data.tfe_organization.this.name
  email = var.hcp_terraform_organization.email

  assessments_enforced = var.hcp_terraform_organization.assessments_enforced
}

resource "tfe_organization_membership" "this" {
  for_each = data.tfe_organization_membership.this

  organization = tfe_organization.this.name
  email        = each.value.email
}

resource "tfe_team" "owners" {
  name         = data.tfe_team.owners.name
  organization = tfe_organization.this.name
}

resource "tfe_team_organization_members" "owners" {
  team_id                     = tfe_team.owners.id
  organization_membership_ids = local.owners_team_organization_membership_ids
}

resource "tfe_project" "default" {
  name         = data.tfe_project.default.name
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}
