module "terraform_tfe_bootstrap" {
  source = "../"

  # Override some default values.
  tfe_organization = {
    session_timeout_minutes = 480
    cost_estimation_enabled = true
  }
}
