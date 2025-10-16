# The resources for the workspace configured in `backend.tf` can be found in `bootstrap.tf`.

resource "tfe_workspace" "platform_team_shared_services" {
  for_each = var.environments

  name         = "${var.shared_services_workspace_name}-${each.key}"
  organization = tfe_organization.this.name
  project_id   = tfe_project.backend.id

  auto_apply            = true
  queue_all_runs        = true
  terraform_version     = var.terraform_version
  file_triggers_enabled = false

  vcs_repo {
    branch         = each.key
    identifier     = "${var.github_organization_name}/${var.shared_services_vcs_repository_name}"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}
