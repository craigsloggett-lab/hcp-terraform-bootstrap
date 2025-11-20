variable "hcp_terraform_organization" {
  type        = map(any)
  description = "The configuration for the tfe_organization resource."
  default = {
    email                                                   = "craig.sloggett@hashicorp.com"
    session_timeout_minutes                                 = 20160
    session_remember_minutes                                = 20160
    collaborator_auth_policy                                = "password"
    enforce_hyok                                            = false
    owners_team_saml_role_id                                = "owners"
    cost_estimation_enabled                                 = false
    send_passing_statuses_for_untriggered_speculative_plans = false
    aggregated_commit_status_enabled                        = false
    speculative_plan_management_enabled                     = true
    assessments_enforced                                    = true
    allow_force_delete_workspaces                           = false
  }
}
