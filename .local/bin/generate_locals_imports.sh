#!/bin/sh
#
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
# Ensure `TF_TOKEN_app_terraform_io` is set before running:
# $ export TF_TOKEN_app_terraform_io="your-token-here"
#
# Then execute the script from the root of this repository:
# $ .local/bin/generate_locals_imports
#
# Dependencies:
#   - jq (for JSON parsing)
#   - terraform (for formatting output)
#   - curl (for querying the API)

set -eu

# Check if the required utilities are installed.
for utility in jq terraform curl; do
  command -v "${utility}" >/dev/null || {
    printf '%s\n' "Error: ${utility} is not installed." >&2
    exit 1
  }
done

# Check if the required `TF_TOKEN_app_terraform_io` environment variable is set.
tf_token="${TF_TOKEN_app_terraform_io:?'parameter is null or not set. Use export TF_TOKEN_app_terraform_io="" to set this parameter.'}"

# Define important paths.
script_path="$(cd "$(dirname "$0")" && pwd)"
tfvars_path="${script_path}/../../defaults.auto.tfvars"
locals_imports_path="${script_path}/../../locals_imports.tf"

[ -f "${tfvars_path}" ] || {
  printf '%s\n' "Error: ${tfvars_path} not found, unable to get the organization name." >&2
  exit 1
}

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

# Get the HCP Terraform organization name from the required `hcp_terraform_organization_name` terraform variable.
organization_name="$(grep '^hcp_terraform_organization_name' "${tfvars_path}" | cut -d'=' -f2 | tr -d ' "')"

# Set the `curl` options once so we can just write `curl "$@"` everywhere.
set -- --silent --header "Authorization: Bearer ${tf_token}" --header "Content-Type: application/vnd.api+json"

# Clear the `locals_imports.tf` file.
: >"${locals_imports_path}"

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
# # This file is generated automatically using: `.local/bin/generate_locals_imports`.
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
#     variable_set_ids = {
#       "variable_set" = "id"
#     }
#     workspace_ids = {
#       "workspace" = "id"
#     }
#     ssh_key_ids = {
#       "ssh_key" = "id"
#     }
#     notification_configuration_ids = {
#       "notification" = "id"
#     }
#     oauth_client_ids = {
#       "oauth_client" = "id"
#     }
#     policy_set_ids = {
#       "policy_set" = "id"
#     }
#     registry_module_ids = {
#       "module" = "id"
#     }
#     run_task_ids = {
#       "run_task" = "id"
#     }
#     agent_pool_ids = {
#       "agent_pool" = "id"
#     }
#   }
# }
#
# Finally, `terraform fmt` is used to automatically format the output, ensuring
# consistent spacing and alignment. This allows us to focus on generating the
# content without manually adjusting spacing in the `printf` commands.

{
  # shellcheck disable=SC2016
  printf '# This file is generated automatically using: `.local/bin/generate_locals_imports`.\n'
  printf '%s\n' "locals {"
  printf '%s\n' "imports = {"
} >>"${locals_imports_path}"

team_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/teams |
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
} >>"${locals_imports_path}"

owners_team_id="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/teams |
    jq -r '.data[] | select(.attributes.name == "owners") | .id'
)"

owners_team_organization_membership_ids="$(
  curl "$@" https://app.terraform.io/api/v2/teams/"${owners_team_id}" |
    jq -r '.data.relationships."organization-memberships".data[].id' |
    while read -r organization_membership_id; do
      email="$(
        curl "$@" https://app.terraform.io/api/v2/organization-memberships/"${organization_membership_id}" |
          jq -r '.data.attributes.email'
      )"
      print_attribute "${email}" "${organization_membership_id}"
    done
)"

{
  printf '%s\n' "organization_membership_ids = {"
  printf '%s\n' "owners = {"
  printf '%s\n' "${owners_team_organization_membership_ids}"
  printf '%s\n%s\n' "}" "}"
} >>"${locals_imports_path}"

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
} >>"${locals_imports_path}"

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
} >>"${locals_imports_path}"

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
} >>"${locals_imports_path}"

ssh_key_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/ssh-keys |
    jq -r '.data[].id' |
    while read -r ssh_key_id; do
      ssh_key_name="$(
        curl "$@" https://app.terraform.io/api/v2/ssh-keys/"${ssh_key_id}" |
          jq -r '.data.attributes.name'
      )"
      print_attribute "${ssh_key_name}" "${ssh_key_id}"
    done
)"

if [ -n "${ssh_key_ids}" ]; then
  {
    printf '%s\n' "ssh_key_ids = {"
    printf '%s\n' "${ssh_key_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

notification_configuration_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/workspaces |
    jq -r '.data[].id' |
    while read -r workspace_id; do
      curl "$@" https://app.terraform.io/api/v2/workspaces/"${workspace_id}"/notification-configurations |
        jq -r '.data[]? | .id' |
        while read -r notification_id; do
          notification_name="$(
            curl "$@" https://app.terraform.io/api/v2/notification-configurations/"${notification_id}" |
              jq -r '.data.attributes.name'
          )"
          print_attribute "${notification_name}" "${notification_id}"
        done
    done
)"

if [ -n "${notification_configuration_ids}" ]; then
  {
    printf '%s\n' "notification_configuration_ids = {"
    printf '%s\n' "${notification_configuration_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

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
  } >>"${locals_imports_path}"
fi

policy_set_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/policy-sets |
    jq -r '.data[].id' |
    while read -r policy_set_id; do
      policy_set_name="$(
        curl "$@" https://app.terraform.io/api/v2/policy-sets/"${policy_set_id}" |
          jq -r '.data.attributes.name'
      )"
      print_attribute "${policy_set_name}" "${policy_set_id}"
    done
)"

if [ -n "${policy_set_ids}" ]; then
  {
    printf '%s\n' "policy_set_ids = {"
    printf '%s\n' "${policy_set_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

registry_module_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/registry-modules |
    jq -r '.data[].id' |
    while read -r registry_module_id; do
      registry_module_name="$(
        curl "$@" https://app.terraform.io/api/v2/registry-modules/"${registry_module_id}" |
          jq -r '.data.attributes.name'
      )"
      print_attribute "${registry_module_name}" "${registry_module_id}"
    done
)"

if [ -n "${registry_module_ids}" ]; then
  {
    printf '%s\n' "registry_module_ids = {"
    printf '%s\n' "${registry_module_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

run_task_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/tasks |
    jq -r '.data[].id' |
    while read -r run_task_id; do
      run_task_name="$(
        curl "$@" https://app.terraform.io/api/v2/tasks/"${run_task_id}" |
          jq -r '.data.attributes.name'
      )"
      print_attribute "${run_task_name}" "${run_task_id}"
    done
)"

if [ -n "${run_task_ids}" ]; then
  {
    printf '%s\n' "run_task_ids = {"
    printf '%s\n' "${run_task_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

agent_pool_ids="$(
  curl "$@" https://app.terraform.io/api/v2/organizations/"${organization_name}"/agent-pools |
    jq -r '.data[].id' |
    while read -r agent_pool_id; do
      agent_pool_name="$(
        curl "$@" https://app.terraform.io/api/v2/agent-pools/"${agent_pool_id}" |
          jq -r '.data.attributes.name'
      )"
      print_attribute "${agent_pool_name}" "${agent_pool_id}"
    done
)"

if [ -n "${agent_pool_ids}" ]; then
  {
    printf '%s\n' "agent_pool_ids = {"
    printf '%s\n' "${agent_pool_ids}"
    printf '%s\n' "}"
  } >>"${locals_imports_path}"
fi

{
  printf '%s\n%s\n' "}" "}"
} >>"${locals_imports_path}"

# Format the `locals` block.
terraform fmt "${locals_imports_path}"
