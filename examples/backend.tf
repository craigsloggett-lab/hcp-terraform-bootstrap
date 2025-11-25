terraform {
  cloud {
    organization = "craigsloggett-lab" # Update this to match the value of `var.hcp_terraform_organization_name`.

    workspaces {
      project = "Modules"                 # Update this to an appropriate project.
      name    = "terraform-tfe-bootstrap" # Update this to an appropriate workspace.
    }
  }
}
