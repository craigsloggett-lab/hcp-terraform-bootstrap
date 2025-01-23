# The HCP Terraform organization under management.
import {
  id = var.hcp_terraform_organization_name
  to = tfe_organization.this
}

# The `owners` team.
import {
  id = "${var.hcp_terraform_organization_name}/owners"
  to = tfe_team.owners
}

# The organization membership of each user that comes with the HCP Terraform 
# organization. These users are all placed in the `owners` team by default.
import {
  for_each = local.imports.organization_membership_ids.owners
  id       = each.value
  to       = tfe_organization_membership.owners[each.key]
}

# The `owners` team members.
import {
  id = tfe_team.owners.id
  to = tfe_team_organization_members.owners
}

# The `Default Project` project.
import {
  id = local.imports.project_ids["Default Project"]
  to = tfe_project.default
}

# The project that is configured in `backend.tf`.
import {
  id = local.imports.project_ids[var.backend_project_name]
  to = tfe_project.backend
}

# The workspace that is configured in `backend.tf`.
import {
  id = local.imports.workspace_ids[var.backend_workspace_name]
  to = tfe_workspace.backend
}

# The `TFE Provider Authentication` variable set. 
# This contains the `TFE_TOKEN` environment variable used to authenticate the
# TFE provider.
import {
  id = local.imports.variable_set_ids[var.tfe_provider_authentication_variable_set_name]
  to = tfe_variable_set.tfe_provider_authentication
}

# The association between the authentication variable set and the workspace configured in `backend.tf`.
import {
  id = join("/", [
    var.hcp_terraform_organization_name,
    tfe_workspace.backend.name,
    var.tfe_provider_authentication_variable_set_name,
  ])
  to = tfe_workspace_variable_set.backend
}
