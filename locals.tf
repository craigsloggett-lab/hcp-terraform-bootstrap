locals {
  # The output of the `external` data source is a jsonencoded string and
  # so this local variable does the jsondecode in one spot and converts
  # it to a set for convenience when used in a `for_each`.
  owners_team_emails = toset(jsondecode(data.external.owners_team_emails.result.emails))
}
