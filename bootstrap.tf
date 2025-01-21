resource "tfe_organization" "this" {
  name  = var.hcp_terraform_organization_name
  email = var.hcp_terraform_organization_email

  assessments_enforced = true
}

resource "tfe_organization_membership" "owners" {
  for_each     = local.imports.teams.owners.members
  organization = tfe_organization.this.name
  email        = each.value.email
}

resource "tfe_team_organization_members" "owners" {
  team_id = local.imports.teams.owners.id
  organization_membership_ids = [
    for username, attributes in local.imports.teams.owners.members : tfe_organization_membership.owners[username].id
  ]
}

resource "tfe_project" "default" {
  name         = "Default Project"
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}

resource "tfe_variable_set" "tfe_provider_authentication" {
  name         = local.imports.variable_sets.tfe_provider_authentication.name
  description  = "The token used to authenticate the TFE provider for managing this HCP Terraform organization."
  organization = tfe_organization.this.name
}

resource "tfe_workspace_variable_set" "tfe_provider_authentication" {
  workspace_id    = tfe_workspace.hcp_terraform_admin.id
  variable_set_id = tfe_variable_set.tfe_provider_authentication.id
}

resource "tfe_project" "platform_team" {
  name         = var.hcp_platform_team_project_name
  organization = tfe_organization.this.name
  description  = "A collection of workspaces to manage HashiCorp Cloud Platform services."
}

resource "tfe_workspace" "hcp_terraform_admin" {
  name         = var.hcp_terraform_admin_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.platform_team.id

  terraform_version = var.terraform_version
  queue_all_runs    = false
}
