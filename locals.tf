locals {
  # The `owners_team_emails` local variable combines user-provided email 
  # addresses from `var.owners_team_emails` with the default organization 
  # membership emails from `local.imports.organization_membership_ids`. This 
  # ensures that both manually added and system-defined owners are included 
  # without duplicates, as the setunion guarantees uniqueness.
  owners_team_emails = toset(setunion(
    keys(local.imports.organization_membership_ids),
    var.owners_team_emails,
  ))
}
