resource "tfe_workspace" "hcp_terraform_admin" {
  name         = var.hcp_terraform_admin_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.platform_team.id

  terraform_version = var.terraform_version
  queue_all_runs    = false
}
