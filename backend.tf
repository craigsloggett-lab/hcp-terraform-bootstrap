terraform {
  cloud {
    organization = "craigsloggett-lab" # Update the `hcp_terraform_organization_name` variable to match.

    workspaces {
      project = "Platform Team"       # Update the `backend_project_name` variable to match.
      name    = "hcp-terraform-admin" # Update the `backend_workspace_name` variable to match.
    }
  }
}
