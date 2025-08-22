# Public Providers

resource "tfe_registry_provider" "hashicorp" {
  for_each     = toset(["aws", "tfe", "random", "http"])
  organization = tfe_organization.this.name

  registry_name = "public"
  namespace     = "hashicorp"
  name          = each.key
}
