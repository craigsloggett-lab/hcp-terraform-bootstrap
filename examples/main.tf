module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/hcp-terraform-bootstrap?ref=v0.10.0"

  tfe_organization = {
    email = "craig.sloggett@hashicorp.com"
  }
}
