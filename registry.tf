# Public Providers

resource "tfe_registry_provider" "hashicorp" {
  for_each     = toset(["aws", "tfe", "random", "http"])
  organization = tfe_organization.this.name

  registry_name = "public"
  namespace     = "hashicorp"
  name          = each.key
}

# Public Modules

resource "tfe_registry_module" "terraform_aws_vpc" {
  organization    = tfe_organization.this.name
  namespace       = "terraform-aws-modules"
  module_provider = "aws"
  name            = "vpc"
  registry_name   = "public"
}

# Private Modules

resource "tfe_registry_module" "terraform_aws_tfe_fdo_docker_active_active" {
  name         = "tfe-fdo-docker-active-active"
  organization = tfe_organization.this.name

  test_config {
    tests_enabled = true
  }

  vcs_repo {
    display_identifier = "${var.github_organization_name}/terraform-aws-tfe-fdo-docker-active-active"
    identifier         = "${var.github_organization_name}/terraform-aws-tfe-fdo-docker-active-active"
    oauth_token_id     = data.tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }
}

import {
  id = "craigsloggett-lab/private/craigsloggett-lab/tfe-fdo-docker-active-active/aws/mod-t6uoffWBYU9gi7az"
  to = tfe_registry_module.terraform_aws_tfe_fdo_docker_active_active
}

resource "tfe_test_variable" "tfe_license" {
  organization    = tfe_organization.this.name
  module_name     = tfe_registry_module.terraform_aws_tfe_fdo_docker_active_active.name
  module_provider = tfe_registry_module.terraform_aws_tfe_fdo_docker_active_active.module_provider

  key         = "TF_VAR_tfe_license"
  description = "The TFE license used to test the terraform-aws-tfe-fdo-docker-active-active module."
  category    = "env"
}
