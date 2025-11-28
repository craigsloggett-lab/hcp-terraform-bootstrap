# tflint-ignore: terraform_required_version

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = var.hcp_terraform_organization_name
}

# Use the module like a data source to get details about the resources in your organization.
module "bootstrap" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=vx.x.x"
}

# Using the outputs of the module, the default resources
# that come with every new organization can be easily
# imported.

# HCP Terraform Organization

import {
  id = module.bootstrap.tfe_organization.this.name
  to = tfe_organization.this
}

resource "tfe_organization" "this" {
  name  = module.bootstrap.tfe_organization.this.name
  email = module.bootstrap.tfe_organization.this.email

  assessments_enforced = true
}

# HCP Terraform Organization Members (Users)

import {
  for_each = module.bootstrap.tfe_organization_membership

  id = each.key
  to = tfe_organization_membership.this[each.key]
}

resource "tfe_organization_membership" "this" {
  for_each = module.bootstrap.tfe_organization_membership

  email = each.value.email
}

# The "owners" Team

import {
  id = "${module.bootstrap.tfe_organization.this.name}/${module.bootstrap.tfe_team.owners.id}"
  to = tfe_team.owners
}

resource "tfe_team" "owners" {
  name = "owners"
}

# The "owners" Team Members (Users)

import {
  id = module.bootstrap.tfe_team.owners.id
  to = tfe_team_organization_members.owners
}

resource "tfe_team_organization_members" "owners" {
  team_id                     = tfe_team.owners.id
  organization_membership_ids = module.bootstrap.tfe_team.owners.organization_membership_ids
}

# The "Default Project" Project

import {
  id = module.bootstrap.tfe_project.default.id
  to = tfe_project.default
}

# tflint-ignore: terraform_required_providers
resource "tfe_project" "default" {
  name        = "Default Project"
  description = "The default project for new workspaces."
}
