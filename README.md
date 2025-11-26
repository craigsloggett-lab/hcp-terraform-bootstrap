# HCP Terraform and Terraform Enterprise Bootstrap

A Terraform module to easily bootstrap an HCP Terraform or TFE organization.

The outputs of the module expose the necessary `id` values to be used in `import` blocks by the consuming root module. Each output is named after the `tfe` provider resource it is discovering and they are generally maps with the name of the resource as the `key` and an `id` or other relevant data as the values.

The value this module provides is discovering and gathering all of the resources configured in HCP Terraform and exposing the relevant `id`s needed to bring them under management with `import`.

This is similar in concept to the `query` functionality introduced in recent versions of `terraform` however, it doesn't require the `tfe` provider to be updated with `list` resources for every resource and will work with older Terraform versions (`v1.5.0` and later if the consumer uses `import` blocks).

Long term, the aim is to implement resource discovery using list blocks as the feature and provider matures, giving users the ability to both discover unmanaged resources and generate the code to manage them.

If you haven't setup an HCP Terraform organization yet, the [Manual Onboarding Setup](#Manual-Onboarding-Setup) section below walks you through the steps to get started.

<!-- BEGIN_TF_DOCS -->
## Usage

### main.tf
```hcl
module "bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/terraform-tfe-bootstrap?ref=v0.12.0"
}

resource "tfe_organization" "this" {
  name  = module.bootstrap.tfe_organization.this.name
  email = module.bootstrap.tfe_organization.this.email

  assessments_enforced = true
}

resource "tfe_organization_membership" "this" {
  for_each = module.bootstrap.tfe_organization_membership

  email = each.value.email
}

resource "tfe_team" "owners" {
  name = "owners"
}

resource "tfe_team_organization_members" "owners" {
  team_id                     = tfe_team.owners.id
  organization_membership_ids = module.bootstrap.tfe_team.owners.organization_membership_ids
}

resource "tfe_project" "default" {
  name        = "Default Project"
  description = "The default project for new workspaces."
}
```

### imports.tf
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_external"></a> [external](#requirement\_external) | 2.3.5 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.71.0 |

## Inputs

No inputs.

## Resources

| Name | Type |
|------|------|
| [external_external.owners_team_emails](https://registry.terraform.io/providers/hashicorp/external/2.3.5/docs/data-sources/external) | data source |
| [external_external.variable_set_names](https://registry.terraform.io/providers/hashicorp/external/2.3.5/docs/data-sources/external) | data source |
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization) | data source |
| [tfe_organization_members.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization_members) | data source |
| [tfe_organization_membership.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization_membership) | data source |
| [tfe_organizations.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organizations) | data source |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/project) | data source |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/team) | data source |
| [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/variable_set) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfe_organization"></a> [tfe\_organization](#output\_tfe\_organization) | A map of the HCP Terraform organizations details including 'id' and 'name'. Only inludes 'this' organization. |
| <a name="output_tfe_organization_membership"></a> [tfe\_organization\_membership](#output\_tfe\_organization\_membership) | A list containing details about the HCP Terraform organization members. |
| <a name="output_tfe_project"></a> [tfe\_project](#output\_tfe\_project) | A map of the HCP Terraform projects with their 'id' as the only key. Only includes the 'Default Project' project. |
| <a name="output_tfe_team"></a> [tfe\_team](#output\_tfe\_team) | A map of the HCP Terraform teams with their 'id' as the only key. Only includes the 'owners' team. |
| <a name="output_tfe_variable_set"></a> [tfe\_variable\_set](#output\_tfe\_variable\_set) | A map of variable sets and their details as configured in the HCP Terraform organization. |
<!-- END_TF_DOCS -->

## Manual Onboarding Setup

The following steps can be used as a guide when onboarding a new repository.

### HashiCorp Cloud Platform

1. Create an HCP account.
2. Create an HCP organization.
3. Create an HCP project.

### HCP Terraform

1. Create an HCP Terraform organization.
2. Run `terraform login` to generate a user API token.
3. Update `backend.tf` to use your HCP Terraform organization.
4. Run `terraform init` to create the backend workspace and project.
5. Manually generate a team API token for the "owners" team.
6. Manually create a variable set for the purpose of authenticating the TFE provider.
7. Populate the variable set with the `TFE_TOKEN` environment variable, using the API token as the (sensitive) value.
8. Assign the variable set to the backend workspace (or project).

#### VCS Integration with GitHub

In order to scope the list of repositories shown to users when creating a VCS backed workspace,
it is necessary to create and install an OAuth App in your GitHub organization. Using a service
account is not strictly required but is recommended in order to ensure _only_ repositories for
an organization are listed -- and not those belonging to a user.

##### Creating a GitHub Service Account

Create a GitHub service account by navigating to https://github.com/signup and creating a new
user with a unique email and username. This user is like any other human user, but will be
configured with a private profile and own no repositories.

##### Add the Service Account to the GitHub Organization

Once created, add the service account as a member of the GitHub organization being integrated
with HCP Terraform.

##### Create an OAuth App in the GitHub Organization

Navigate to GitHub organization settings -> Developer settings -> OAuth Apps to create a new
OAuth App for the _organization_ (not an individual user).

The Application name, Homepage URL, and Authorization callback URL fields will be populated
with information found in HCP Terraform. Device flow can be enabled if desired, but does
not affect the process either way.

Pause here and open a new window/tab with the HCP Terraform organization open and logged in
as a user with access to add a VCS Provider.

###### Add a VCS Provider

Navigate to HCP Terraform organization settings -> Version Control -> Providers to Add a VCS provider.
Select GitHub -> GitHub.com (Custom) to display the information needed to populate the OAuth application
registration form.

Back in GitHub, within the OAuth App registration window/tab, copy the Application name, Homepage URL,
and Authorization callback URL into the relevant fields in the OAuth App configuration.

Click Register application and copy the Client ID into the Add VCS Provider window in HCP Terraform and
give the VCS Provider the same name as the GitHub organization being configured.

Finally, in the OAuth App, Generate a new client secret, and copy the secret into the Add VCS Provider
window in HCP Terraform.

Click Connect and continue to begin the authorization workflow between HCP Terraform and GitHub. At this
point it is important to be logged into GitHub using your _service account_ created earlier, not your
user account. It is important to note that the email used for the GitHub _service account_ does not need
to be a member of the HCP Terraform organization.
