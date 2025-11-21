variable "tfe_organization" {
  description = "The default arguments for the resources being managed by this module, allowing users to override them."
  type = object({
    collaborator_auth_policy                                = optional(string, "password")
    owners_team_saml_role_id                                = optional(string, "owners")
    session_timeout_minutes                                 = optional(number, 20160)
    session_remember_minutes                                = optional(number, 20160)
    enforce_hyok                                            = optional(bool, false)
    cost_estimation_enabled                                 = optional(bool, false)
    send_passing_statuses_for_untriggered_speculative_plans = optional(bool, false)
    aggregated_commit_status_enabled                        = optional(bool, false)
    speculative_plan_management_enabled                     = optional(bool, true)
    assessments_enforced                                    = optional(bool, true)
    allow_force_delete_workspaces                           = optional(bool, false)
  })
}
