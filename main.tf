# Default Resources

resource "tfe_organization" "this" {
  name  = var.hcp_terraform_organization_name
  email = var.hcp_terraform_organization_email

  assessments_enforced = true
}

resource "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.this.name
}

resource "tfe_organization_membership" "owners" {
  for_each     = local.owners_team_emails
  organization = tfe_organization.this.name
  email        = each.value
}

resource "tfe_team_organization_members" "owners" {
  team_id = tfe_team.owners.id
  organization_membership_ids = [
    for email in local.owners_team_emails : tfe_organization_membership.owners[email].id
  ]
}

resource "tfe_project" "default" {
  name         = "Default Project"
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}

# Terraform Backend Resources (Created at First Terraform Run)

resource "tfe_project" "backend" {
  name         = var.backend_project_name
  organization = tfe_organization.this.name
  description  = "A collection of workspaces to manage the HCP Terraform platform."
}

resource "tfe_workspace" "backend" {
  name         = var.backend_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.backend.id

  auto_apply            = true
  queue_all_runs        = true
  terraform_version     = var.terraform_version
  file_triggers_enabled = false

  vcs_repo {
    identifier     = "${var.github_organization_name}/${var.backend_vcs_repository_name}"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

# Created Manually to Facilitate the Bootstrap Process

resource "tfe_variable_set" "tfe_provider_authentication" {
  name         = var.tfe_provider_authentication_variable_set_name
  description  = "The token used to authenticate the TFE provider for managing this HCP Terraform organization."
  organization = tfe_organization.this.name
}

# Provide TFE provider credentials to the workspaces in this project.
resource "tfe_project_variable_set" "backend" {
  variable_set_id = tfe_variable_set.tfe_provider_authentication.id
  project_id      = tfe_project.backend.id
}

data "tfe_oauth_client" "github" {
  organization     = tfe_organization.this.id
  service_provider = "github"
}

# Create an admin team to eliminate the need to give owners access to new users.
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

# Create an admin workspace to manage the rest of the HCP Terraform organization.
resource "tfe_workspace" "admin" {
  name         = var.admins_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.backend.id

  auto_apply            = true
  queue_all_runs        = true
  terraform_version     = var.terraform_version
  file_triggers_enabled = false

  vcs_repo {
    identifier     = "${var.github_organization_name}/${var.admins_workspace_name}"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}
