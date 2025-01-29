# The resources for the workspace configured in `backend.tf` can be found in `bootstrap.tf`.

resource "tfe_workspace" "aws_tfe_fdo_docker_active_active_module" {
  name         = "terraform-aws-tfe-fdo-docker-active-active"
  organization = tfe_organization.this.name
  project_id   = tfe_project.modules.id

  auto_apply        = true
  queue_all_runs    = true
  terraform_version = var.terraform_version

  vcs_repo {
    identifier     = "${var.github_organization_name}/terraform-aws-tfe-fdo-docker-active-active"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable" "tfe_license" {
  key          = "tfe_license"
  value        = var.tfe_license
  category     = "terraform"
  workspace_id = tfe_workspace.aws_tfe_fdo_docker_active_active_module.id
  description  = "The license for Terraform Enterprise."
}
