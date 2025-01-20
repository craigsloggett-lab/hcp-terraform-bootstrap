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
3. Run `terraform init` to create the backend workspace.
4. Manually generate a team API token for the "owners" team.
5. Manually create a variable set named "TFE Provider Authentication".
6. Populate the variable set with the `TFE_TOKEN` environment variable, using the API token as the (sensitive) value.
7. Assign the variable set to the backend workspace.
8. Update `locals.tf` with the ID of the resources in your HCP Terraform organization.

#### Populate `locals.tf`

To get a list of the relevant IDs needed to populate `locals.tf`, review and 
run the script in [`.local/bin/get_ids.sh`](.local/bin/get_ids.sh).

> [!NOTE]  
> The `get_ids.sh` script requires that [`jq(1)`](https://jqlang.github.io/jq/) be installed.

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
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/project) | resource |
| [tfe_project.platform_team](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/project) | resource |
| [tfe_team.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team) | resource |
| [tfe_team_organization_members.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_organization_members) | resource |
| [tfe_team_organization_members.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_organization_members) | resource |
| [tfe_team_project_access.admins](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/team_project_access) | resource |
| [tfe_variable_set.tfe_provider_authentication](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/variable_set) | resource |
| [tfe_workspace.hcp_terraform_admin](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.tfe_provider_authentication](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/resources/workspace_variable_set) | resource |
| [tfe_organization_membership.api_org](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_organization_membership.api_team](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_organization_membership.doormat](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_organization_membership.gh_webhooks](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_organization_membership.owner](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/organization_membership) | data source |
| [tfe_team.owners](https://registry.terraform.io/providers/hashicorp/tfe/0.62.0/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcp_platform_team_project_name"></a> [hcp\_platform\_team\_project\_name](#input\_hcp\_platform\_team\_project\_name) | The name of the project used to manage HashiCorp Cloud Platform services. | `string` | `"Platform Team"` | no |
| <a name="input_hcp_terraform_admin_workspace_name"></a> [hcp\_terraform\_admin\_workspace\_name](#input\_hcp\_terraform\_admin\_workspace\_name) | The name of the workspace used to manage this HCP Terraform organization. | `string` | `"hcp-terraform-admin"` | no |
| <a name="input_hcp_terraform_admins_team_name"></a> [hcp\_terraform\_admins\_team\_name](#input\_hcp\_terraform\_admins\_team\_name) | The name of the team of users who administer the HCP Terraform organization. | `string` | `"admins"` | no |
| <a name="input_hcp_terraform_organization_email"></a> [hcp\_terraform\_organization\_email](#input\_hcp\_terraform\_organization\_email) | The notification email address for the HCP Terraform organization being managed. | `string` | `"craig.sloggett@hashicorp.com"` | no |
| <a name="input_hcp_terraform_organization_name"></a> [hcp\_terraform\_organization\_name](#input\_hcp\_terraform\_organization\_name) | The name of the HCP Terraform organization being managed. | `string` | `"craigsloggett-lab"` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform to use in all workspaces. | `string` | `"1.10.3"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
