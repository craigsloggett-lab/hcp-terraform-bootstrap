locals {
  imports = {
    organization_membership_ids = {
      "craig.sloggett@hashicorp.com"                           = "ou-tSVPjvXHB4iTqcPb"
      "doormat@hashicorp.com"                                  = "ou-9KRr8gq4h6JikktE"
      "api-org-craigsloggett-lab-xqsus22ynh@hashicorp.com"     = "ou-EhS6WkPBDVPxYYqd"
      "api-team_1202828@hashicorp.com"                         = "ou-mLy6EZTkP2bKW9w3"
      "gh-webhooks-craigsloggett-lab-db12onjulf@hashicorp.com" = "ou-j7QUTL6CcJUktJJC"
    }
    project_ids = {
      default_project = "prj-1ifijXyay7xeH9Zc"
      platform_team   = "prj-qW7NitPW1R49WN4b"
    }
    variable_set_ids = {
      tfe_provider_authentication = "varset-FwFGK65suTr7eaAA"
    }
    workspace_ids = {
      hcp_terraform_admin = "ws-aAUcuGF6QEJKuQyL"
    }
  }
}

# The HCP Terraform organization.
import {
  id = var.hcp_terraform_organization_name # Organizations can only be imported by name.
  to = tfe_organization.this
}

# The `owners` team.
import {
  id = "${var.hcp_terraform_organization_name}/owners"
  to = tfe_team.owners
}

# The `owners` team members.
import {
  id = tfe_team.owners.id
  to = tfe_team_organization_members.owners
}

# The organization membership of each user that comes with the HCP Terraform organization.
# These users are all placed in the `owners` team by default.
import {
  for_each = local.imports.organization_membership_ids
  id       = each.value
  to       = tfe_organization_membership.owners[each.key]
}

# The `Default Project` project.
import {
  id = local.imports.project_ids.default_project
  to = tfe_project.default
}

# The project that is configured in `backend.tf`.
import {
  id = local.imports.project_ids.platform_team
  to = tfe_project.platform_team
}

# The workspace that is configured in `backend.tf`.
import {
  id = local.imports.workspace_ids.hcp_terraform_admin
  to = tfe_workspace.hcp_terraform_admin
}

# The `TFE Provider Authentication` variable set. 
# This contains the `TFE_TOKEN` for managing this organization in the workspace configured in `backend.tf`.
import {
  id = local.imports.variable_set_ids.tfe_provider_authentication
  to = tfe_variable_set.tfe_provider_authentication
}

# The association between the authentication variable set and the workspace configured in `backend.tf`.
import {
  id = join("/", [
    var.hcp_terraform_organization_name,
    tfe_workspace.hcp_terraform_admin.name,
    var.tfe_provider_authentication_variable_set_name,
  ])
  to = tfe_workspace_variable_set.tfe_provider_authentication
}
