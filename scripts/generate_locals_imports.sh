#!/bin/sh

# generate_locals_imports - Automatically generate a `locals` block with resource
#                           IDs to be used to import Terraform resources.
#
# This script queries the HCP Terraform API to retrieve various
# organization-specific IDs and generates a Terraform `locals` block
# containing these values. The `locals` block is output to a file in the root
# of this repository named `locals_imports.tf` so it can be used to import
# resources.
#
# Usage:
# Ensure `TF_TOKEN_app_terraform_io` is set to a "Team Token" for the _owners_
# team before running:
# $ export TF_TOKEN_app_terraform_io="your-token-here"
#
# Then execute the script from the root of this repository:
# $ scripts/generate_locals_imports.sh
#
# Dependencies:
#   - jq (for JSON parsing)
#   - terraform (for formatting output)
#   - curl (for querying the API)
main() {
  set -eu

  # Ensure required environment variables have been set.
  : "${TF_TOKEN_app_terraform_io:?"<-- this required environment variable is not set."}"

  # Check if the required utilities are installed.
  for utility in jq terraform curl; do
    command -v "${utility}" >/dev/null || {
      printf '%s\n' "Error: ${utility} is not installed." >&2
      exit 1
    }
  done

  script_path="$(cd "$(dirname "$0")" && pwd)"
  module_path="${script_path}/.."
  locals_imports_file="${module_path}/locals_imports.tf"

  # Check if the identifier is valid HCL syntax.
  valid_identifier() {
    case $1 in
      # Match any string that is:
      # - empty
      # - starts with an invalid character
      # - contains invalid characters
      '' | [!A-Za-z_]* | *[!A-Za-z0-9_-]*)
        return 1
        ;;
      *)
        return 0
        ;;
    esac
  }

  # Print a valid HCL attribute, quoting invalid identifiers as needed.
  print_attribute() {
    key=$1
    value=$2
    if valid_identifier "${key}"; then
      printf '%s = "%s"\n' "${key}" "${value}"
    else
      printf '"%s" = "%s"\n' "${key}" "${value}"
    fi
  }

  # Clear the `locals_imports.tf` file.
  : >"${locals_imports_file}"

  # The rest of this script will generate a `locals` block by querying the
  # HCP Terraform API for the relevant ID using the `TF_TOKEN_app_terraform_io`
  # environment variable to authenticate.
  #
  # The general flow is:
  # - Use `printf` to populate the HCL surrounding the IDs to query.
  # - Use `curl` to query the relevant API endpoint.
  # - Use `jq` to filter for the relevant resources / IDs.
  # - Use a `while read -r variable_name; do` loop to iterate over
  #   queries that require nested `curl` commands to get the necessary
  #   IDs.
  # - Use `printf` to populate the HCL block with the results from the
  #   queries and filters.
  #
  # The generated file will resemble the following structure, with the appropriate
  # IDs populated based on the HCP Terraform organization being managed:
  #
  # # This file is generated automatically using:
  # `scripts/generate_locals_imports.sh`
  #
  # locals {
  #   imports = {
  #     team_ids = {
  #       owners = "id"
  #     }
  #     organization_membership_ids = {
  #       owners = {
  #         "email" = "id"
  #       }
  #     }
  #     project_ids = {
  #       "project" = "id"
  #     }
  #     workspace_ids = {
  #       "workspace" = "id"
  #     }
  #     variable_set_ids = {
  #       "variable_set" = "id"
  #     }
  #     oauth_client_ids = {
  #       "oauth_client" = "id"
  #     }
  #   }
  # }
  #
  # Finally, `terraform fmt` is used to automatically format the output, ensuring
  # consistent spacing and alignment. This allows us to focus on generating the
  # content without manually adjusting spacing in the `printf` commands.

  {
    printf '# This file is generated automatically using:\n'
    # shellcheck disable=SC2016
    printf '# `scripts/generate_locals_imports.sh`\n\n'
    printf 'locals {\n'
    printf 'imports = {\n'
  } >>"${locals_imports_file}"

  tf_token="${TF_TOKEN_app_terraform_io}"

  # Set the `curl` options once so we can just write `curl "$@"` everywhere.
  set -- --silent --header "Authorization: Bearer ${tf_token}" --header "Content-Type: application/vnd.api+json"

  organization_name="$(
    curl "$@" https://app.terraform.io/api/v2/organizations |
      jq -r '.data[].attributes.name'
  )"

  teams_json="$(curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/teams)"

  team_ids="$(
    printf '%s\n' "${teams_json}" |
      jq -r '.data[].id' |
      while read -r team_id; do
        team_name="$(
          curl "$@" https://app.terraform.io/api/v2/teams/"${team_id}" |
            jq -r '.data.attributes.name'
        )"
        print_attribute "${team_name}" "${team_id}"
      done
  )"

  {
    printf '%s\n' "team_ids = {"
    printf '%s\n' "${team_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_file}"

  owners_team_id="$(
    printf '%s\n' "${teams_json}" |
      jq -r '.data[] | select(.attributes.name == "owners") | .id'
  )"

  owners_team_organization_membership_ids="$(
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

        email="$(
          printf '%s\n' "${organization_membership_json}" |
            jq -r '.data.attributes.email'
        )"

        if ! curl "$@" https://app.terraform.io/api/v2/users/"${user_id}" |
          jq -e '.data.attributes."is-service-account"' >/dev/null; then
          print_attribute "${email}" "${organization_membership_id}"
        fi
      done
  )"

  {
    printf '%s\n' "organization_membership_ids = {"
    printf '%s\n' "owners = {"
    printf '%s\n' "${owners_team_organization_membership_ids}"
    printf '%s\n%s\n' "}" "}"
  } >>"${locals_imports_file}"

  project_ids="$(
    curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/projects |
      jq -r '.data[].id' |
      while read -r project_id; do
        project_name="$(
          curl "$@" https://app.terraform.io/api/v2/projects/"${project_id}" |
            jq -r '.data.attributes.name'
        )"
        print_attribute "${project_name}" "${project_id}"
      done
  )"

  {
    printf '%s\n' "project_ids = {"
    printf '%s\n' "${project_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_file}"

  variable_set_ids="$(
    curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/varsets |
      jq -r '.data[].id' |
      while read -r variable_set_id; do
        variable_set_name="$(
          curl "$@" https://app.terraform.io/api/v2/varsets/"${variable_set_id}" |
            jq -r '.data.attributes.name'
        )"
        print_attribute "${variable_set_name}" "${variable_set_id}"
      done
  )"

  {
    printf '%s\n' "variable_set_ids = {"
    printf '%s\n' "${variable_set_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_file}"

  workspace_ids="$(
    curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/workspaces |
      jq -r '.data[].id' |
      while read -r workspace_id; do
        workspace_name="$(
          curl "$@" https://app.terraform.io/api/v2/workspaces/"${workspace_id}" |
            jq -r '.data.attributes.name'
        )"
        print_attribute "${workspace_name}" "${workspace_id}"
      done
  )"

  {
    printf '%s\n' "workspace_ids = {"
    printf '%s\n' "${workspace_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_file}"

  oauth_client_ids="$(
    curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/oauth-clients |
      jq -r '.data[].id' |
      while read -r oauth_client_id; do
        oauth_client_name="$(
          curl "$@" https://app.terraform.io/api/v2/oauth-clients/"${oauth_client_id}" |
            jq -r '.data.attributes.name'
        )"
        print_attribute "${oauth_client_name}" "${oauth_client_id}"
      done
  )"

  if [ -n "${oauth_client_ids}" ]; then
    {
      printf '%s\n' "oauth_client_ids = {"
      printf '%s\n' "${oauth_client_ids}"
      printf '%s\n' "}"
    } >>"${locals_imports_file}"
  fi

  {
    printf '%s\n%s\n' "}" "}"
  } >>"${locals_imports_file}"

  # Format the `locals` block.
  terraform fmt "${locals_imports_file}"
}

main "$@"
