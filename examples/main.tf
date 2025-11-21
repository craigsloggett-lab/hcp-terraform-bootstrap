module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=v0.10.1"

  # Override some default values.
  tfe_organization = {
    session_timeout_minutes = 480
    cost_estimation_enabled = true
  }
}
