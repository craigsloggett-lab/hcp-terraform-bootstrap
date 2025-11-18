import {
  id = module.terraform_tfe_bootstrap.hcp_terraform_organization_name
  to = module.terraform_tfe_bootstrap.tfe_organization.this
}

import {
  id = "${module.terraform_tfe_bootstrap.hcp_terraform_organization_name}/owners"
  to = module.terraform_tfe_bootstrap.tfe_team.owners
}

import {
  for_each = module.terraform_tfe_bootstrap.hcp_terraform_organization_membership

  id = each.key
  to = module.terraform_tfe_bootstrap.tfe_organization_membership.this[each.key]
}

import {
  id = module.terraform_tfe_bootstrap.default_project_id
  to = module.terraform_tfe_bootstrap.tfe_project.default
}
