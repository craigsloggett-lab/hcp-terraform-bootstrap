resource "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.this.name
}

resource "tfe_organization_membership" "owners" {
  for_each     = local.imports.organization_membership_ids
  organization = tfe_organization.this.name
  email        = each.key
}

resource "tfe_team_organization_members" "owners" {
  team_id = tfe_team.owners.id
  organization_membership_ids = [
    for email, id in local.imports.organization_membership_ids : tfe_organization_membership.owners[email].id
  ]
}

resource "tfe_team" "admins" {
  name         = var.hcp_terraform_admins_team_name
  organization = tfe_organization.this.name
  visibility   = "secret"

  organization_access {
    access_secret_teams        = true
    manage_agent_pools         = true
    manage_membership          = true
    manage_modules             = true
    manage_organization_access = false
    manage_policies            = true
    manage_policy_overrides    = true
    manage_projects            = true
    manage_providers           = true
    manage_run_tasks           = true
    manage_teams               = true
    manage_vcs_settings        = true
    manage_workspaces          = true
    read_projects              = true
    read_workspaces            = true
  }
}

data "tfe_organization_membership" "admins" {
  for_each     = var.admins_team_emails
  organization = tfe_organization.this.name
  email        = each.key
}

resource "tfe_team_organization_members" "admins" {
  team_id                     = tfe_team.admins.id
  organization_membership_ids = [for email in var.admins_team_emails : data.tfe_organization_membership.admins[email].id]
}

resource "tfe_team_project_access" "admins" {
  access     = "admin"
  team_id    = tfe_team.admins.id
  project_id = tfe_project.platform_team.id
}
