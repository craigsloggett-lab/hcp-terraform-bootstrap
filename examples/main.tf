module "terraform_tfe_bootstrap" {
  # TODO: Reference the public registry once published.
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=v0.11.0"
  #version = "X.X.X" # Add this parameter once it is published.
}

data "tfe_organization" "this" {
  name = "craigsloggett-lab"
}

resource "tfe_organization" "this" {
  name  = data.tfe_organization.this.name
  email = data.tfe_organization.this.email

  # Organization configuration.
  assessments_enforced = true
}

resource "tfe_organization_membership" "this" {
  for_each = module.terraform_tfe_bootstrap.tfe_organization_membership

  organization = tfe_organization.this.name
  email        = each.value.email
}

resource "tfe_team" "owners" {
  organization = tfe_organization.this.name
  name         = "owners"
}

resource "tfe_team_organization_members" "owners" {
  team_id                     = tfe_team.owners.id
  organization_membership_ids = module.terraform_tfe_bootstrap.tfe_team.owners.organization_membership_ids
}

resource "tfe_project" "default" {
  organization = tfe_organization.this.name
  name         = "Default Project"
  description  = "The default project for new workspaces."
}
