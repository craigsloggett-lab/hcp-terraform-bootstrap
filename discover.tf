# This external data source will query the HCP Terraform API for a list of
# variable sets that are configured in the organization.
data "external" "variable_sets" {
  program = ["sh", "${path.module}/scripts/get_variable_sets.sh"]

  query = {
    organization_name = data.tfe_organization.this.name
  }
}
