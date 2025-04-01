# Required
hcp_terraform_organization_name  = "craigsloggett-lab"
hcp_terraform_organization_email = "craig.sloggett@hashicorp.com"
backend_project_name             = "Platform Team"
backend_workspace_name           = "hcp-terraform-admin"
backend_vcs_repository_name      = "hcp-terraform-admin"
github_organization_name         = "craigsloggett-lab"

# Optional
terraform_version                             = "1.10.3"
tfe_provider_authentication_variable_set_name = "TFE Provider Authentication"
aws_provider_authentication_variable_set_name = "AWS Provider Authentication"

owners_team_emails = [
  "craig.sloggett@hashicorp.com",
]

hcp_terraform_admins_team_name = "admins"

admins_team_emails = [
  "craig.sloggett@hashicorp.com",
]

## Lab Infrastructure
vps_relay_workspace_name      = "terraform-aws-vps-relay"
vps_relay_vcs_repository_name = "terraform-aws-vps-relay"
