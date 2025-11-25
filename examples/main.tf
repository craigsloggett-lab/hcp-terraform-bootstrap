module "terraform_tfe_bootstrap" {
  # TODO: Reference the public registry once published.
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=remove-resource-blocks"
  #version = "X.X.X" # Add this parameter once it is published.
}

data "tfe_organizations" "this" {}

data "tfe_organization" "this" {
  name = data.tfe_organizations.this.names[0]

  lifecycle {
    precondition {
      condition     = length(data.tfe_organizations.this.names) == 1
      error_message = "Expected exactly one TFE organization for this token, but found ${length(data.tfe_organizations.this.names)}."
    }
  }
}

data "tfe_organization_members" "this" {
  organization = data.tfe_organization.this.name
}

data "tfe_organization_membership" "this" {
  for_each = toset(data.tfe_organization_members.this.members[*].organization_membership_id)

  organization               = data.tfe_organization.this.name
  organization_membership_id = each.value
}

resource "tfe_organization" "this" {
  name  = module.bootstrap.tfe_organization.this.name
  email = data.tfe_organization.this.email

  assessments_enforced = true
}

resource "tfe_organization_membership" "this" {
  for_each = data.tfe_organization_membership.this

  organization = tfe_organization.this.name
  email        = each.value.email
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
