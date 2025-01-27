#resource "tfe_oauth_client" "test" {
#  name                = "github-oauth-client"
#  organization        = "my-org-name"
#  api_url             = "https://api.github.com"
#  http_url            = "https://github.com"
#  oauth_token         = "my-vcs-provider-token"
#  service_provider    = "github"
#  organization_scoped = true
#}

#data "tfe_github_app_installation" "gha_installation" {
#  name = "craigsloggett-org"
#}
#
#output "github_app_id" {
#  value = data.tfe_github_app_installation.gha_installation
#}

resource "tfe_workspace" "terraform_aws_tfe_fdo_docker_active_active" {
  name           = "terraform-aws-tfe-fdo-docker-active-active"
  organization   = tfe_organization.this.id
  queue_all_runs = false
  vcs_repo {
    branch                     = "main"
    identifier                 = "craigsloggett-lab/terraform-aws-tfe-fdo-docker-active-active"
    github_app_installation_id = "ghain-kHaW9XtcS8N1QN6E"
  }
}
