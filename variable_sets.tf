resource "tfe_variable_set" "tfe_provider_authentication" {
  name         = var.tfe_provider_authentication_variable_set_name
  description  = "The token used to authenticate the TFE provider for managing this HCP Terraform organization."
  organization = tfe_organization.this.name
}

resource "tfe_workspace_variable_set" "tfe_provider_authentication" {
  workspace_id    = tfe_workspace.hcp_terraform_admin.id
  variable_set_id = tfe_variable_set.tfe_provider_authentication.id
}
