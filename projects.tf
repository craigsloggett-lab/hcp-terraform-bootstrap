resource "tfe_project" "default" {
  name         = "Default Project"
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}

resource "tfe_project" "platform_team" {
  name         = var.hcp_platform_team_project_name
  organization = tfe_organization.this.name
  description  = "A collection of workspaces to manage HashiCorp Cloud Platform services."
}
