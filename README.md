# HCP Terraform and Terraform Enterprise Bootstrap

A Terraform module to easily bootstrap an HCP Terraform or TFE organization.

The outputs of the module expose the necessary `id` values to be used in
`import` blocks by the consuming root module.

The [resources](#Resources) in this module are expected to be imported as
shown below in the examples.

Each of these resources have all of their attributes exposed as values
to be optionally overridden by the module input arguments.

If you haven't setup an HCP Terraform organization yet, the
[Manual Onboarding Setup](#Manual-Onboarding-Setup) section below
walks you through the steps to get started.

<!-- BEGIN_TF_DOCS -->
## Usage

### main.tf
```hcl
module "terraform_tfe_bootstrap" {
  source = "git::https://github.com/craigsloggett-lab/hcp-terraform-bootstrap?ref=v0.10.0"

  # Override some default values.
  tfe_organization = {
    session_timeout_minutes = 480
    cost_estimation_enabled = true
  }
}
```

### imports.tf
```hcl
# The HCP Terraform organization.
import {
  id = module.terraform_tfe_bootstrap.tfe_organizations.this.name
  to = module.terraform_tfe_bootstrap.tfe_organization.this
}

# The members of the HCP Terraform organization.
import {
  for_each = module.terraform_tfe_bootstrap.tfe_organization_memberships

  id = each.key
  to = module.terraform_tfe_bootstrap.tfe_organization_membership.this[each.key]
}

# The "owners" team.
import {
  id = "${module.terraform_tfe_bootstrap.tfe_organizations.this.name}/${module.terraform_tfe_bootstrap.tfe_teams.owners.id}"
  to = module.terraform_tfe_bootstrap.tfe_team.owners
}

# The members of the "owners" team.
import {
  id = module.terraform_tfe_bootstrap.tfe_teams.owners.id
  to = module.terraform_tfe_bootstrap.tfe_team_organization_members.owners
}

# The "Default Project" project.
import {
  id = module.terraform_tfe_bootstrap.tfe_projects.default.id
  to = module.terraform_tfe_bootstrap.tfe_project.default
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tfe_organization"></a> [tfe\_organization](#input\_tfe\_organization) | The default arguments for the resources being managed by this module, allowing users to override them. | <pre>object({<br/>    collaborator_auth_policy                                = optional(string, "password")<br/>    owners_team_saml_role_id                                = optional(string, "owners")<br/>    session_timeout_minutes                                 = optional(number, 20160)<br/>    session_remember_minutes                                = optional(number, 20160)<br/>    enforce_hyok                                            = optional(bool, false)<br/>    cost_estimation_enabled                                 = optional(bool, false)<br/>    send_passing_statuses_for_untriggered_speculative_plans = optional(bool, false)<br/>    aggregated_commit_status_enabled                        = optional(bool, false)<br/>    speculative_plan_management_enabled                     = optional(bool, true)<br/>    assessments_enforced                                    = optional(bool, true)<br/>    allow_force_delete_workspaces                           = optional(bool, false)<br/>  })</pre> | n/a | yes |

## Resources

| Name | Type |
|------|------|
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/resources/organization) | resource |
| [tfe_organization_membership.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/resources/organization_membership) | resource |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/resources/project) | resource |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/resources/team) | resource |
| [tfe_team_organization_members.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/resources/team_organization_members) | resource |
| [external_external.owners_team_emails](https://registry.terraform.io/providers/hashicorp/external/2.3.5/docs/data-sources/external) | data source |
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization) | data source |
| [tfe_organization_members.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization_members) | data source |
| [tfe_organization_membership.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organization_membership) | data source |
| [tfe_organizations.this](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/organizations) | data source |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/project) | data source |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.71.0/docs/data-sources/team) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfe_organization_memberships"></a> [tfe\_organization\_memberships](#output\_tfe\_organization\_memberships) | A map of the HCP Terraform organization members, intended to be iterated over to discover users. |
| <a name="output_tfe_organizations"></a> [tfe\_organizations](#output\_tfe\_organizations) | A map of the HCP Terraform organizations details including 'id' and 'name'. Only inludes 'this' organization. |
| <a name="output_tfe_projects"></a> [tfe\_projects](#output\_tfe\_projects) | A map of the HCP Terraform projects with their 'id' as the only key. Only includes the 'Default Project' project. |
| <a name="output_tfe_teams"></a> [tfe\_teams](#output\_tfe\_teams) | A map of the HCP Terraform teams with their 'id' as the only key. Only includes the 'owners' team. |
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
