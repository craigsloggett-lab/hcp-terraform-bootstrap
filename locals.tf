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
}
