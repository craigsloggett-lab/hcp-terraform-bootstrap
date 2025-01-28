data "tfe_registry_gpg_keys" "all" {
  organization = tfe_organization.this.id
}

# Add the following providers:
# - AWS
# - TFE
# - HTTP
# - Random

# Add the following modules:
# - AWS VPC
# - My TFE AWS one
