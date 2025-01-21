import {
  id = var.hcp_terraform_organization_name # Organizations can only be imported by name.
  to = tfe_organization.this
}

import {
  for_each = local.imports.teams.owners.members
  id       = each.value.organization_membership_id
  to       = tfe_organization_membership.owners[each.key]
}

import {
  id = local.imports.teams.owners.id
  to = tfe_team_organization_members.owners
}

import {
  id = local.imports.projects.default_project.id
  to = tfe_project.default
}

import {
  id = local.imports.variable_sets.tfe_provider_authentication.id
  to = tfe_variable_set.tfe_provider_authentication
}

import {
  id = join("/", [
    var.hcp_terraform_organization_name,
    tfe_workspace.hcp_terraform_admin.name,
    local.imports.variable_sets.tfe_provider_authentication.name,
  ])
  to = tfe_workspace_variable_set.tfe_provider_authentication
}

import {
  id = local.imports.projects.platform_team.id
  to = tfe_project.platform_team
}

import {
  id = local.imports.workspaces.hcp_terraform_admin.id
  to = tfe_workspace.hcp_terraform_admin
}
