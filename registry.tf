data "tfe_registry_gpg_keys" "all" {
  organization = tfe_organization.this.id
}
