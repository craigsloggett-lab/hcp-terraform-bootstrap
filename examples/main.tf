module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=0.10.0"

  # Override some default values.
  tfe_organization = {
    session_timeout_minutes = 480
    cost_estimation_enabled = true
  }
}
