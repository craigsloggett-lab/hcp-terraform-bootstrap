# The resources for the workspace configured in `backend.tf` can be found in `bootstrap.tf`.

resource "tfe_workspace" "terraform_aws_vps_relay" {
  name         = var.vps_relay_workspace_name
  organization = tfe_organization.this.name
  project_id   = tfe_project.lab.id

  auto_apply        = true
  queue_all_runs    = true
  terraform_version = var.terraform_version

  vcs_repo {
    identifier     = "${var.github_organization_name}/${var.vps_relay_vcs_repository_name}"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}
