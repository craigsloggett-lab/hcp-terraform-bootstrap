# These are expected to be imported by the consuming root module as showcased in the examples/ directory.

resource "tfe_organization" "this" {
  name  = data.tfe_organization.this.name
  email = data.tfe_organization.this.email

  # The following configuration is set to sane defaults but can be overridden if needed.
  collaborator_auth_policy                                = var.tfe_organization.collaborator_auth_policy
  owners_team_saml_role_id                                = var.tfe_organization.owners_team_saml_role_id
  session_timeout_minutes                                 = var.tfe_organization.session_timeout_minutes
  session_remember_minutes                                = var.tfe_organization.session_remember_minutes
  enforce_hyok                                            = var.tfe_organization.enforce_hyok
  cost_estimation_enabled                                 = var.tfe_organization.cost_estimation_enabled
  send_passing_statuses_for_untriggered_speculative_plans = var.tfe_organization.send_passing_statuses_for_untriggered_speculative_plans
  aggregated_commit_status_enabled                        = var.tfe_organization.aggregated_commit_status_enabled
  speculative_plan_management_enabled                     = var.tfe_organization.speculative_plan_management_enabled
  assessments_enforced                                    = var.tfe_organization.assessments_enforced
  allow_force_delete_workspaces                           = var.tfe_organization.allow_force_delete_workspaces
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
  team_id                     = tfe_team.owners.id
  organization_membership_ids = local.owners_team_organization_membership_ids
}

resource "tfe_project" "default" {
  name         = data.tfe_project.default.name
  organization = tfe_organization.this.name
  description  = "The default project for new workspaces."
}
