locals {
  owners_team_id     = "team-p9ryLNrpQ9TNmEFh"
  default_project_id = "prj-1ifijXyay7xeH9Zc"

  # The TFE Provider Authentication variable set.
  tfe_provider_authentication_variable_set_id           = "varset-FwFGK65suTr7eaAA"
  tfe_provider_authentication_workspace_variable_set_id = "craigsloggett-lab/hcp-terraform-admin/TFE Provider Authentication"

  # The resources defined in `backend.tf`.
  hcp_terraform_admin_workspace_id = "ws-aAUcuGF6QEJKuQyL"
  hcp_platform_team_project_id     = "prj-qW7NitPW1R49WN4b"

  # Hidden users for HashiCorp's internal systems.
  hidden_users_organization_membership_ids = {
    api_org     = "ou-EhS6WkPBDVPxYYqd"
    api_team    = "ou-mLy6EZTkP2bKW9w3"
    gh_webhooks = "ou-j7QUTL6CcJUktJJC"
  }
}
