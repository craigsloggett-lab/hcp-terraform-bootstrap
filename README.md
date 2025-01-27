# hcp-terraform-admin

An infrastructure as code repository to manage an HCP Terraform organization.

TEST

## Manual Setup

The following steps must be taken before being able to run the code in this repository.

### HashiCorp Cloud Platform

1. Create an HCP account.
2. Create an HCP organization.
3. Create an HCP project.

### HCP Terraform

1. Create an HCP Terraform organization.
2. Run `terraform login` to generate a user API token.
3. Run `terraform init` to create the backend workspace.
4. Manually generate a team API token for the "owners" team.
5. Manually create a variable set named "TFE Provider Authentication".
6. Populate the variable set with the `TFE_TOKEN` environment variable, using the API token as the (sensitive) value.
7. Assign the variable set to the backend workspace.
8. Generate a `locals_imports.tf` file with the IDs of the resources in your HCP Terraform organization.

#### Generate `locals_imports.tf`

To generate a `locals` block containing the IDs of the resources to bring under
management, review and run the script in [`.local/bin/generate_locals_imports`](.local/bin/generate_locals_imports):

#### VCS Integration with GitHub


1. Login to the organization with a user who has access to the GitHub organization you want to configure 
   a VCS provider for.
2. Navigate to Workspaces -> New -> Workspace
3. Select "Default Project"
4. Select Version Control Workflow
5. Select GitHub -> GitHub.com
6. Complete the authorization flow
7. Click the GitHub organization to list available organizations
8. Click Add another organization to authorize repositories for the org you want
9. Complete the authorization flow
10. Click cancel (no need to create a workspace)
11. Navigate to User Icon -> Account Settings -> Tokens
12. Copy the GitHub App Installation ID into this repository's terraform.tfvars file

To setup VCS integration with a GitHub organization instead of an individual user (recommended), 
the following manual steps must be taken by an admin of the organization:

1. Login to HCP Terraform as an admin of the platform.
2. Navigate to Organization Settings -> Version Control Providers.
3. Add a VCS provider by clicking the button.
4. Select GitHub.com (Custom) (pause and open a new tab).
5. Login to GitHub as a user who is allowed to manage GitHub Apps belonging to the organization.
6. Navigate to Settings -> Developer settings -> GitHub Apps.
7. Register a new app by clicking the New GitHub App button.
8. Refer back to the HCP Terraform form to get the required field values.
9. Deselect Webhook -> Active.
10. Expand Repository permissions and update Contents -> Read-only.
11. Ensure this GitHub App can only be installed on the lab account.
12. Create the app by clicking Create Github App.
13. Copy the new client ID into HCP Terraform under Client ID.
14. In the GitHub App settings page, generate a new client secret by clicking the relevant button.
15. Copy the new client secret into HCP Terraform under Client Secret.
16. In the GitHub App settings page, click Save changes to complete the client secret creation. 
17. In HCP Terraform, click Connect and Continue to begin the authorization flow.
18. Authorize the GitHub App to allow permission to the items listed.
19. Finalize the VCS provider setup by clicking the Skip and finish button.


```sh
export TF_TOKEN_app_terraform_io="" /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/craigsloggett-lab/hcp-terraform-admin/refs/heads/main/.local/bin/generate_locals_imports)"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.62.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/organization) | resource |
| [tfe_organization_membership.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/organization_membership) | resource |
| [tfe_project.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/project) | resource |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/project) | resource |
| [tfe_team.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team) | resource |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team) | resource |
| [tfe_team_organization_members.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_organization_members) | resource |
| [tfe_team_organization_members.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_organization_members) | resource |
| [tfe_team_project_access.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_project_access) | resource |
| [tfe_variable_set.tfe_provider_authentication](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/variable_set) | resource |
| [tfe_workspace.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/workspace) | resource |
| [tfe_workspace.terraform_aws_tfe_fdo_docker_active_active](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.backend](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/workspace_variable_set) | resource |
| [tfe_organization_membership.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_registry_gpg_keys.all](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/registry_gpg_keys) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins_team_emails"></a> [admins\_team\_emails](#input\_admins\_team\_emails) | A list of member email addresses for the admins team. | `set(string)` | `[]` | no |
| <a name="input_backend_project_name"></a> [backend\_project\_name](#input\_backend\_project\_name) | The name of the project used to manage this HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_backend_workspace_name"></a> [backend\_workspace\_name](#input\_backend\_workspace\_name) | The name of the workspace used to manage this HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_hcp_terraform_admins_team_name"></a> [hcp\_terraform\_admins\_team\_name](#input\_hcp\_terraform\_admins\_team\_name) | The name of the team of users who administer the HCP Terraform organization. | `string` | `"admins"` | no |
| <a name="input_hcp_terraform_organization_email"></a> [hcp\_terraform\_organization\_email](#input\_hcp\_terraform\_organization\_email) | The notification email address for the HCP Terraform organization being managed. | `string` | n/a | yes |
| <a name="input_hcp_terraform_organization_name"></a> [hcp\_terraform\_organization\_name](#input\_hcp\_terraform\_organization\_name) | The name of the HCP Terraform organization being managed. | `string` | n/a | yes |
| <a name="input_owners_team_emails"></a> [owners\_team\_emails](#input\_owners\_team\_emails) | A list of member email addresses for the owners team. | `set(string)` | `[]` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform to use in all workspaces. | `string` | `"1.10.3"` | no |
| <a name="input_tfe_provider_authentication_variable_set_name"></a> [tfe\_provider\_authentication\_variable\_set\_name](#input\_tfe\_provider\_authentication\_variable\_set\_name) | The name of the variable set used to authenticate the TFE provider. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_available_registry_gpg_keys"></a> [available\_registry\_gpg\_keys](#output\_available\_registry\_gpg\_keys) | A list of all of the GPG keys in this organization. |
<!-- END_TF_DOCS -->
