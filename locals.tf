locals {
  # The output of the `external` data source is a jsonencoded string so
  # this local variable does the jsondecode in one spot and converts it
  # to a "set" for convenience when used with "for_each".
  owners_team_emails = toset(jsondecode(data.external.owners_team_emails.result.emails))

  owners_team_organization_membership_ids = [
    for id, membership in data.tfe_organization_membership.this : membership.organization_membership_id
    if contains(local.owners_team_emails, membership.email)
  ]

  # The output of the `external` data source is a jsonencoded string so
  # this local variable does the jsondecode in one spot and converts it
  # to a "set" for convenience when used with "for_each".
  variable_set_names = toset(jsondecode(data.external.variable_set_names.result.names))

  # The `tfe_variable_set` data source includes the variable IDs, but
  # not any details about the variables.
  variable_sets_without_variables = {
    for name in local.variable_set_names :
    data.tfe_variable_set.this[name].id => data.tfe_variable_set.this[name]
  }

  # The `tfe_variable` data source contains a lot of duplicate data so
  # this will clean it up and prepare it to be merged into the relevant
  # variable set map that is output by this module.
  variable_set_variables = {
    for name, variable_set in data.tfe_variables.this :
    variable_set.variable_set_id => {
      for variable in variable_set.variables :
      variable.id => variable
    }
  }

  # Merge the variable set data with the variable data associated with
  # each variable set, giving a convenient place to import variable sets
  # and their relevant variables.
  variable_sets = {
    for id, variable_set in local.variable_sets_without_variables :
    id => merge(
      variable_set,
      {
        variables = try(local.variable_set_variables[id], {})
      }
    )
  }
}
