# The HCP Terraform organization.
import {
  id = module.bootstrap.tfe_organization.this.name
  to = tfe_organization.this
}

# The members of the HCP Terraform organization.
import {
  for_each = module.bootstrap.tfe_organization_membership

  id = each.key
  to = tfe_organization_membership.this[each.key]
}

# The "owners" team.
import {
  id = "${module.bootstrap.tfe_organization.this.name}/${module.bootstrap.tfe_team.owners.id}"
  to = tfe_team.owners
}

# The members of the "owners" team.
import {
  id = module.bootstrap.tfe_team.owners.id
  to = tfe_team_organization_members.owners
}

# The "Default Project" project.
import {
  id = module.bootstrap.tfe_project.default.id
  to = tfe_project.default
}
