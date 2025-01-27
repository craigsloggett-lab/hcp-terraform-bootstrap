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

resource "tfe_project" "backend" {
  name         = var.backend_project_name
  organization = tfe_organization.this.name
  description  = "A collection of workspaces to manage platform services."
}

resource "tfe_workspace" "backend" {
  name         = var.backend_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.backend.id

  terraform_version = var.terraform_version
  queue_all_runs    = true

  vcs_repo {
    identifier     = "${var.github_organization_name}/${var.backend_vcs_repository_name}"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable_set" "tfe_provider_authentication" {
  name         = var.tfe_provider_authentication_variable_set_name
  description  = "The token used to authenticate the TFE provider for managing this HCP Terraform organization."
  organization = tfe_organization.this.name
}

resource "tfe_workspace_variable_set" "backend" {
  workspace_id    = tfe_workspace.backend.id
  variable_set_id = tfe_variable_set.tfe_provider_authentication.id
}
