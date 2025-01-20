#!/bin/sh

tf_token="<HCP_TERRAFORM_API_TOKEN>"
organization_name="<HCP_TERRAFORM_ORGANIZATION_NAME>"

# The owners team ID is used in the organization membership ID query, so
# we assign it to a variable.
owners_team_id="$(
  curl --silent \
    --header "Authorization: Bearer ${tf_token}" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/organizations/"${organization_name}"/teams |
    jq -r '.data[] | select(.attributes.name == "owners") | .id'
)"

# Display the owners team ID.
printf '%s\n' "Team ID               Team Name"
printf '%s\n' "--------------------- ---------"
printf '%s %s\n\n' "${owners_team_id}" "owners"

# Display the organization membership IDs.
printf '%s\n' "Org Membership ID   Username"
printf '%s\n' "------------------- ----------------------------------------"
curl --silent \
  --header "Authorization: Bearer ${tf_token}" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/teams/"${owners_team_id}" |
  jq -r '.data.relationships."organization-memberships".data[].id' |
  while read -r organization_membership_id; do
    curl --silent \
      --header "Authorization: Bearer ${tf_token}" \
      --header "Content-Type: application/vnd.api+json" \
      https://app.terraform.io/api/v2/organization-memberships/"${organization_membership_id}" |
      jq -r '.data.relationships.user.data.id' |
      while read -r user_id; do
        username="$(curl --silent \
          --header "Authorization: Bearer ${tf_token}" \
          --header "Content-Type: application/vnd.api+json" \
          https://app.terraform.io/api/v2/users/"${user_id}" |
          jq -r '.data.attributes.username')"
        printf '%s %s\n' "${organization_membership_id}" "${username}"
      done
  done

# Display the variable set IDs.
printf '\n%s\n' "Variable Set ID         Variable Set Name"
printf '%s\n' "----------------------- ---------------------------"
curl --silent \
  --header "Authorization: Bearer ${tf_token}" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/"${organization_name}"/varsets |
  jq -r '.data[].id' |
  while read -r variable_set_id; do
    variable_set_name="$(curl --silent \
      --header "Authorization: Bearer ${tf_token}" \
      --header "Content-Type: application/vnd.api+json" \
      https://app.terraform.io/api/v2/varsets/"${variable_set_id}" |
      jq -r '.data.attributes.name')"
    printf '%s %s\n' "${variable_set_id}" "${variable_set_name}"
  done

# Display the project IDs.
printf '\n%s\n' "Project ID           Project Name"
printf '%s\n' "-------------------- ---------------"
curl --silent \
  --header "Authorization: Bearer ${tf_token}" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/"${organization_name}"/projects |
  jq -r '.data[].id' |
  while read -r project_id; do
    project_name="$(curl --silent \
      --header "Authorization: Bearer ${tf_token}" \
      --header "Content-Type: application/vnd.api+json" \
      https://app.terraform.io/api/v2/projects/"${project_id}" |
      jq -r '.data.attributes.name')"
    printf '%s %s\n' "${project_id}" "${project_name}"
  done

# Display the workspace IDs.
printf '\n%s\n' "Workspace ID        Workspace Name"
printf '%s\n' "------------------- -------------------"
curl --silent \
  --header "Authorization: Bearer ${tf_token}" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/"${organization_name}"/workspaces |
  jq -r '.data[].id' |
  while read -r workspace_id; do
    workspace_name="$(curl --silent \
      --header "Authorization: Bearer ${tf_token}" \
      --header "Content-Type: application/vnd.api+json" \
      https://app.terraform.io/api/v2/workspaces/"${workspace_id}" |
      jq -r '.data.attributes.name')"
    printf '%s %s\n' "${workspace_id}" "${workspace_name}"
  done
