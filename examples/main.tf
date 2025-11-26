module "bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=add-variable-sets"
}

resource "tfe_organization" "this" {
  name  = module.bootstrap.tfe_organization.this.name
  email = module.bootstrap.tfe_organization.this.email

  assessments_enforced = true
}

resource "tfe_organization_membership" "this" {
  for_each = module.bootstrap.tfe_organization_membership

  email = each.value.email
}

resource "tfe_team" "owners" {
  name = "owners"
}

resource "tfe_team_organization_members" "owners" {
  team_id                     = tfe_team.owners.id
  organization_membership_ids = module.bootstrap.tfe_team.owners.organization_membership_ids
}

resource "tfe_project" "default" {
  name        = "Default Project"
  description = "The default project for new workspaces."
}
