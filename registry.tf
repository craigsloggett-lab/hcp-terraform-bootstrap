import {
  for_each = toset(["aws", "tfe", "random", "http"])
  id       = "${tfe_organization.this.name}/public/hashicorp/${each.key}"
  to       = tfe_registry_provider.hashicorp[each.key]
}

resource "tfe_registry_provider" "hashicorp" {
  for_each     = toset(["aws", "tfe", "random", "http"])
  organization = tfe_organization.this.name

  registry_name = "public"
  namespace     = "hashicorp"
  name          = each.key
}

import {
  id = "${tfe_organization.this.name}/public/terraform-aws-modules/vpc/aws/mod-d85dapELcpKjeUo8"
  to = tfe_registry_module.terraform_aws_vpc
}

resource "tfe_registry_module" "terraform_aws_vpc" {
  organization    = tfe_organization.this.name
  namespace       = "terraform-aws-modules"
  module_provider = "aws"
  name            = "vpc"
  registry_name   = "public"
}
