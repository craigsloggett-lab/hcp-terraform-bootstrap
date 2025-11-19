terraform {
  cloud {
    organization = "craigsloggett-lab"

    workspaces {
      project = "Administration"
      name    = "terraform-tfe-bootstrap"
    }
  }
}
