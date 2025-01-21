variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the HCP Terraform organization being managed."
}

variable "hcp_terraform_organization_email" {
  type        = string
  description = "The notification email address for the HCP Terraform organization being managed."
}

variable "hcp_terraform_admin_workspace_name" {
  type        = string
  description = "The name of the workspace used to manage this HCP Terraform organization."
  default     = "hcp-terraform-admin"
}

variable "hcp_platform_team_project_name" {
  type        = string
  description = "The name of the project used to manage HashiCorp Cloud Platform services."
  default     = "Platform Team"
}

variable "tfe_provider_authentication_variable_set_name" {
  type        = string
  description = "The name of the variable set used to offer authentication to the TFE provider."
  default     = "TFE Provider Authentication"
}

variable "hcp_terraform_admins_team_name" {
  type        = string
  description = "The name of the team of users who administer the HCP Terraform organization."
  default     = "admins"
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use in all workspaces."
  default     = "1.10.3"
}
