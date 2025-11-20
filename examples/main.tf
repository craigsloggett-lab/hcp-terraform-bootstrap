# This module requires no inputs, all of the "magic" can be seen in the `imports.tf` file.

module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/hcp-terraform-bootstrap?ref=restructure-as-module"

  hcp_terraform_organization = {
    allow_force_delete_workspaces = false

  }
}
