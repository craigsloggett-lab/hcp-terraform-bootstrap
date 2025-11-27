#!/bin/sh

# get_owners_team_emails - Get the set of emails associated with the owners
#                          team HCP Terraform.
#
# This script queries the HCP Terraform API to retrieve the email addresses
# of the users in the owners team. It is expected to be used with the
# external data source and so the inputs and outputs obey a specific protocol
# as defined in the provider documentation.
#
# Usage:
# Ensure `TFE_TOKEN` is set to a "Team Token" for the _owners_ team before
# running:
# $ export TFE_TOKEN="your-token-here"
#
# Then add the following Terraform code to your root module:
# data "external" "owners_team_emails" {
#   program = ["sh", "${path.module}/scripts/get_owners_team_emails.sh"]
# }
#
# Dependencies:
#   - jq (for JSON parsing)
#   - curl (for querying the API)
main() {
  set -eu

  # Ensure required environment variables have been set.
  : "${TFE_TOKEN:?"<-- this required environment variable is not set."}"

  # Check if the required utilities are installed.
  for utility in jq curl; do
    command -v "${utility}" >/dev/null || {
      printf '%s\n' "Error: ${utility} is not installed." >&2
      exit 1
    }
  done

  # Set API connection configuration.
  tfe_token="${TFE_TOKEN}"
  organization_name="$(jq -r '.organization_name')"

  # Set the `curl` options once so we can just write `curl "$@"` everywhere.
  set -- --silent --header "Authorization: Bearer ${tfe_token}" --header "Content-Type: application/vnd.api+json"

  teams_json="$(curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/teams)"

  owners_team_id="$(
    printf '%s\n' "${teams_json}" |
      jq -r '.data[] | select(.attributes.name == "owners") | .id'
  )"

  owners_team_emails="$(
    curl "$@" https://app.terraform.io/api/v2/teams/"${owners_team_id}" |
      jq -r '.data.relationships."organization-memberships".data[].id' |
      while read -r organization_membership_id; do
        organization_membership_json="$(
          curl "$@" https://app.terraform.io/api/v2/organization-memberships/"${organization_membership_id}"
        )"

        user_id="$(
          printf '%s\n' "${organization_membership_json}" |
            jq -r '.data.relationships.user.data.id'
        )"

        if ! curl "$@" https://app.terraform.io/api/v2/users/"${user_id}" |
          jq -e '.data.attributes."is-service-account"' >/dev/null; then
          # Output one email per line.
          printf '%s\n' "${organization_membership_json}" |
            jq -r '.data.attributes.email'
        fi
      done |
      jq --raw-input --null-input '{"emails": ( [inputs] | unique | tojson )}'
  )"

  printf '%s\n' "${owners_team_emails}"
}

main "$@"
