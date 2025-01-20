import {
  id = var.hcp_terraform_organization_name # Organizations can only be imported by name.
  to = tfe_organization.this
}

import {
  id = local.owners_team_id
  to = tfe_team_organization_members.owners
}

import {
  id = local.default_project_id
  to = tfe_project.default
}

import {
  id = local.tfe_provider_authentication_variable_set_id
  to = tfe_variable_set.tfe_provider_authentication
}

import {
  id = local.tfe_provider_authentication_workspace_variable_set_id
  to = tfe_workspace_variable_set.tfe_provider_authentication
}

import {
  id = local.hcp_platform_team_project_id
  to = tfe_project.platform_team
}

import {
  id = local.hcp_terraform_admin_workspace_id
  to = tfe_workspace.hcp_terraform_admin
}
