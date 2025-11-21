module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=v0.10.2"

  # Optionally, override some or all of the default values
  # for the `tfe_organization` resource.
  tfe_organization = {
    session_timeout_minutes = 480
    cost_estimation_enabled = true
  }
}
