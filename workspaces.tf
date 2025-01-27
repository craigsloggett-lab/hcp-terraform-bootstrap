# The resources for the workspace configured in `backend.tf` can be found in `bootstrap.tf`.

resource "tfe_workspace" "terraform_aws_tfe_fdo_docker_active_active" {
  name         = "terraform-aws-tfe-fdo-docker-active-active"
  organization = tfe_organization.this.name
  project_id   = tfe_project.backend.id

  terraform_version = var.terraform_version
  queue_all_runs    = true

  vcs_repo {
    identifier     = "${var.github_organization_name}/terraform-aws-tfe-fdo-docker-active-active"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}
