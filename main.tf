# Data Sources
# These are exposed by the module as outputs to be used in the import blocks by the consumer.

# List all organizations available with the credentials being used by the TFE provider.
data "tfe_organizations" "this" {}

# The credentials should only have access to one (1) organization.
data "tfe_organization" "this" {
  name = data.tfe_organizations.this.names[0]

  lifecycle {
    precondition {
      condition     = length(data.tfe_organizations.this.names) == 1
      error_message = "Expected exactly one TFE organization for this token, but found ${length(data.tfe_organizations.this.names)}."
    }
  }
}

# List all members (users) of the organization.
data "tfe_organization_members" "this" {
  organization = data.tfe_organization.this.name
}

# Get basic information about the members (users) of the organization.
data "tfe_organization_membership" "this" {
  for_each = toset(data.tfe_organization_members.this.members[*].organization_membership_id)

  organization               = tfe_organization.this.name
  organization_membership_id = each.value
}

# Get a list of member (user) emails associated with the `owners` team.
data "external" "owners_team_emails" {
  program = ["sh", "${path.module}/scripts/get_owners_team_emails.sh"]

  query = {
    organization_name = tfe_organization.this.name
  }
}

# Get details about the Default Project created by default in every HCP Terraform instance.
data "tfe_project" "default" {
  name         = "Default Project"
  organization = data.tfe_organization.this.name
}

# Resources
# These are the resources being managed, they are expected to be imported by the consumer of this module.

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
  name         = "owners"
  organization = tfe_organization.this.name
}

resource "tfe_project" "default" {
  name         = "Default Project"
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}
