data "tfe_oauth_client" "github" {
  organization     = tfe_organization.this.id
  service_provider = "github"
}
