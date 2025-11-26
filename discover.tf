# This external data source will query the HCP Terraform API for a list of
# variable sets that are configured in the organization.
data "external" "variable_set_names" {
  program = ["sh", "${path.module}/scripts/get_variable_sets.sh"]

  query = {
    organization_name = data.tfe_organization.this.name
  }
}

data "tfe_variable_set" "this" {
  for_each = local.variable_set_names
  name     = each.key
}

data "tfe_variable_set" "aws" {
  id = "varset-V3aKs1pXjHJWeEHk"
}
