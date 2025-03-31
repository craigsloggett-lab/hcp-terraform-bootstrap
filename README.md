# hcp-terraform-admin

An infrastructure as code repository to manage an HCP Terraform organization.

## Manual Setup

The following steps must be taken before being able to run the code in this repository.

### HashiCorp Cloud Platform

1. Create an HCP account.
2. Create an HCP organization.
3. Create an HCP project.

### HCP Terraform

1. Create an HCP Terraform organization.
2. Run `terraform login` to generate a user API token.
3. Update `backend.tf` to point to your HCP Terraform organization. You can modify workspace and project as well but not sugggested.
4. Run `terraform init` to create the backend workspace.
5. Manually generate a team API token for the "owners" team.
6. Manually create a variable set for the purpose of authenticating the TFE provider.
7. Populate the variable set with the `TFE_TOKEN` environment variable, using the API token as the (sensitive) value.
8. Assign the variable set to the backend workspace.
9. Create a `terraform.tfvars` file with the values for your HCP Terraform organization.
10. Generate a `locals_imports.tf` file with the IDs of the resources in your HCP Terraform organization.

#### Generate `locals_imports.tf`

To generate a `locals` block containing the IDs of the resources to bring under
management, review and run the script in [`.local/bin/generate_locals_imports`](.local/bin/generate_locals_imports):

```sh
export TF_TOKEN_app_terraform_io="{{your token}}"; /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/craigsloggett-lab/hcp-terraform-admin/refs/heads/main/.local/bin/generate_locals_imports)"
```

#### VCS Integration with GitHub

In order to scope the list of repositories shown to users when creating a VCS backed workspace,
it is necessary to create and install a custom GitHub App in your GitHub organization using a
service account. Using a service account is not strictly required but is recommended in order
to ensure _only_ repositories for an organization are listed--not those belonging to a user.

##### Creating a GitHub Service Account

Create a GitHub service account by navigating to https://github.com/signup and creating a new
user with a unique email and username. This user is like any other human user, but will be 
configured with a private profile and own no repositories.

##### Add the Service Account to the GitHub Organization

Once created, add the service account as an owner of the GitHub organization being integrated
with HCP Terraform.

##### Create a GitHub App in the GitHub Organization

Navigate to GitHub organization settings -> Developer settings -> GitHub Apps to create a new
GitHub App for the _organization_ (not an individual user).

The GitHub App name, Homepage URL, and Callback URL fields will be populated with information 
generated in HCP Terraform so scroll past these parameters for now.

Uncheck the Webhook -> Active checkbox as this is not needed.

Expand the Repository permissions section and change the following options (from the defaults):
- Commit statuses: Read and write
- Contents: Read-only
- Metadata: Read-only
- Webhooks: Read and write

Ensure the GitHub App can only be installed on this account (which should show the organization
as the account).

Pause here and open a new window/tab with the HCP Terraform organization open and logged in
as a user with access to add a VCS Provider.

###### Add a VCS Provider

Navigate to HCP Terraform organization settings -> Version Control -> Providers to Add a VCS provider.
Select GitHub -> GitHub.com (Custom) to display the information needed to populate the GitHub App
creation form.

Back in the GitHub App creation window/tab, copy the Application name, Homepage URL, and Authorization
callback URL into the relevant fields in the GitHub App configuration.

Click Create GitHub App and copy the Client ID into the Add VCS Provider window in HCP Terraform and
give the VCS Provider the same name as the GitHub organization being configured.

Finally, in the GitHub App, Generate a new client secret, and copy the secret into the Add VCS Provider
window in HCP Terraform.

Click Connect and continue to begin the authorization workflow between HCP Terraform and GitHub. At this
point it is important to be logged into GitHub using your _service account_ created earlier, not your
user account. It is important to note that the email used for the GitHub _service account_ does not need
to be a member of the HCP Terraform organization.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.64.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/organization) | resource |
| [tfe_organization_membership.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/organization_membership) | resource |
| [tfe_project.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/project) | resource |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/project) | resource |
| [tfe_project.modules](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/project) | resource |
| [tfe_project_variable_set.modules](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/project_variable_set) | resource |
| [tfe_registry_module.terraform_aws_tfe_fdo_docker_active_active](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/registry_module) | resource |
| [tfe_registry_module.terraform_aws_vpc](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/registry_module) | resource |
| [tfe_registry_provider.hashicorp](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/registry_provider) | resource |
| [tfe_team.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team) | resource |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team) | resource |
| [tfe_team_organization_members.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team_organization_members) | resource |
| [tfe_team_organization_members.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team_organization_members) | resource |
| [tfe_team_project_access.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team_project_access) | resource |
| [tfe_team_project_access.default](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team_project_access) | resource |
| [tfe_team_project_access.modules](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/team_project_access) | resource |
| [tfe_test_variable.tfe_license](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/test_variable) | resource |
| [tfe_variable_set.aws_provider_authentication](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/variable_set) | resource |
| [tfe_variable_set.tfe_provider_authentication](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/variable_set) | resource |
| [tfe_workspace.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/resources/workspace_variable_set) | resource |
| [tfe_oauth_client.github](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/data-sources/oauth_client) | data source |
| [tfe_organization_membership.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.64.0/docs/data-sources/organization_membership) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins_team_emails"></a> [admins\_team\_emails](#input\_admins\_team\_emails) | A list of member email addresses for the admins team. | `set(string)` | `[]` | no |
| <a name="input_aws_provider_authentication_variable_set_name"></a> [aws\_provider\_authentication\_variable\_set\_name](#input\_aws\_provider\_authentication\_variable\_set\_name) | The name of the variable set used to authenticate the AWS provider. | `string` | `"AWS Provider Authentication"` | no |
| <a name="input_backend_project_name"></a> [backend\_project\_name](#input\_backend\_project\_name) | The name of the project used to manage this HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_backend_vcs_repository_name"></a> [backend\_vcs\_repository\_name](#input\_backend\_vcs\_repository\_name) | The name of the GitHub repository backing the backend workspace. | `string` | n/a | yes |
| <a name="input_backend_workspace_name"></a> [backend\_workspace\_name](#input\_backend\_workspace\_name) | The name of the workspace used to manage this HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_github_organization_name"></a> [github\_organization\_name](#input\_github\_organization\_name) | The name of the GitHub organization used as the VCS provider. | `string` | n/a | yes |
| <a name="input_hcp_terraform_admins_team_name"></a> [hcp\_terraform\_admins\_team\_name](#input\_hcp\_terraform\_admins\_team\_name) | The name of the team of users who administer the HCP Terraform organization. | `string` | `"admins"` | no |
| <a name="input_hcp_terraform_organization_email"></a> [hcp\_terraform\_organization\_email](#input\_hcp\_terraform\_organization\_email) | The notification email address for the HCP Terraform organization being managed. | `string` | n/a | yes |
| <a name="input_hcp_terraform_organization_name"></a> [hcp\_terraform\_organization\_name](#input\_hcp\_terraform\_organization\_name) | The name of the HCP Terraform organization being managed. | `string` | n/a | yes |
| <a name="input_owners_team_emails"></a> [owners\_team\_emails](#input\_owners\_team\_emails) | A list of member email addresses for the owners team. | `set(string)` | `[]` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform to use in all workspaces. | `string` | `"1.10.3"` | no |
| <a name="input_tfe_provider_authentication_variable_set_name"></a> [tfe\_provider\_authentication\_variable\_set\_name](#input\_tfe\_provider\_authentication\_variable\_set\_name) | The name of the variable set used to authenticate the TFE provider. | `string` | `"TFE Provider Authentication"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
