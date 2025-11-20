variable "hcp_terraform_organization" {
  description = "The configuration for the tfe_organization resource."
  type = object({
    email                                                   = optional(string, "craig.sloggett@hashicorp.com")
    session_timeout_minutes                                 = optional(number, 20160)
    session_remember_minutes                                = optional(number, 20160)
    collaborator_auth_policy                                = optional(string, "password")
    enforce_hyok                                            = optional(bool, false)
    owners_team_saml_role_id                                = optional(string, "owners")
    cost_estimation_enabled                                 = optional(bool, false)
    send_passing_statuses_for_untriggered_speculative_plans = optional(bool, false)
    aggregated_commit_status_enabled                        = optional(bool, false)
    speculative_plan_management_enabled                     = optional(bool, true)
    assessments_enforced                                    = optional(bool, true)
    allow_force_delete_workspaces                           = optional(bool, false)
  })
  default = {}
}
