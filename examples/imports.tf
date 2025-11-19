# The HCP Terraform organization.
import {
  id = module.terraform_tfe_bootstrap.hcp_terraform_organization_name
  to = module.terraform_tfe_bootstrap.tfe_organization.this
}

# The members of the HCP Terraform organization.
import {
  for_each = module.terraform_tfe_bootstrap.hcp_terraform_organization_membership

  id = each.key
  to = module.terraform_tfe_bootstrap.tfe_organization_membership.this[each.key]
}

# The "owners" team.
import {
  id = "${module.terraform_tfe_bootstrap.hcp_terraform_organization_name}/owners"
  to = module.terraform_tfe_bootstrap.tfe_team.owners
}

# The members of the "owners" team.
import {
  id = module.terraform_tfe_bootstrap.owners_team_id
  to = module.terraform_tfe_bootstrap.tfe_team_organization_members.owners
}

# The "Default Project" project.
import {
  id = module.terraform_tfe_bootstrap.default_project_id
  to = module.terraform_tfe_bootstrap.tfe_project.default
}
