# The `owners` team resources can be found in `bootstrap.tf`.

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

# Provide admin access to the Default Project that comes with HCP Terraform.
resource "tfe_team_project_access" "default" {
  access     = "admin"
  team_id    = tfe_team.admins.id
  project_id = tfe_project.default.id
}

# Provide admin access to the project configured in `backend.tf`.
resource "tfe_team_project_access" "backend" {
  access     = "admin"
  team_id    = tfe_team.admins.id
  project_id = tfe_project.backend.id
}

resource "tfe_team_project_access" "modules" {
  access     = "admin"
  team_id    = tfe_team.admins.id
  project_id = tfe_project.modules.id
}

resource "tfe_team_project_access" "lab" {
  access     = "admin"
  team_id    = tfe_team.admins.id
  project_id = tfe_project.lab.id
}
