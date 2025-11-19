# Data Sources
# These are exposed by the module as outputs to be used in the import blocks by the consumer.

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

  organization               = tfe_organization.this.name
  organization_membership_id = each.value
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = data.tfe_organization.this.name
}

data "external" "owners_team_emails" {
  program = ["sh", "${path.module}/scripts/get_owners_team_emails.sh"]

  query = {
    organization_name = tfe_organization.this.name
  }
}

data "tfe_project" "default" {
  name         = "Default Project"
  organization = data.tfe_organization.this.name
}

# Default Resources
# These are expected to be imported by the consuming root module as showcased in the examples/ directory.

resource "tfe_organization" "this" {
  name  = data.tfe_organization.this.name
  email = "craig.sloggett@hashicorp.com"

  assessments_enforced = true
}

resource "tfe_organization_membership" "this" {
  for_each = data.tfe_organization_membership.this

  organization = tfe_organization.this.name
  email        = each.value.email
}

resource "tfe_team" "owners" {
  name         = data.tfe_team.owners.name
  organization = tfe_organization.this.name
}

resource "tfe_team_organization_members" "owners" {
  team_id = tfe_team.owners.id
  organization_membership_ids = [
    for id, membership in data.tfe_organization_membership.this : membership.organization_membership_id
    if contains(local.owners_team_emails, membership.email)
  ]
}

resource "tfe_project" "default" {
  name         = data.tfe_project.default.name
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}
