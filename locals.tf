locals {
  # The `owners_team_emails` local variable combines user-provided email
  # addresses from `var.owners_team_emails` with the default organization
  # membership emails from `local.imports.organization_membership_ids.owners`.
  # The setunion() function guarantees that both manually added and
  # system-defined owners are included without duplicates.
  owners_team_emails = toset(setunion(
    jsondecode(data.external.owners_team_emails.result.emails)
  ))
}
