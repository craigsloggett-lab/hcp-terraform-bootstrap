#!/bin/sh

# get_variable_sets - Get the variable sets configured in an HCP Terraform
#                     organization.
#
# This script queries the HCP Terraform API to retrieve the variable sets
# configured in an organization. It is expected to be used with the external
# data source and so the inputs and outputs obey a specific protocol as
# defined in the provider documentation.
#
# Usage:
# Ensure `TFE_TOKEN` is set to a "Team Token" for the _owners_ team before
# running:
# $ export TFE_TOKEN="your-token-here"
#
# Then add the following Terraform code to your root module:
# data "external" "variable_sets" {
#   program = ["sh", "${path.module}/scripts/get_variable_sets.sh"]
# }
#
# Dependencies:
#   - jq (for JSON parsing)
#   - terraform (for formatting output)
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

  variable_sets_json="$(curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/varsets)"

  printf '%s\n' "${variable_sets_json}" |
    jq '(
      .data |
        map ({
          key: .id,
          value: {
            id: .id,
            name: .attributes.name
          }
        }) |
      from_entries |
      tojson
    )'
}

main "$@"
