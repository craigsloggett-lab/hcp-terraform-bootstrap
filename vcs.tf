data "tfe_oauth_client" "github" {
  service_provider = "github"
  organization     = tfe_organization.this.name
}
