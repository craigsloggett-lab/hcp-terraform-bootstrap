# Bootstrap Configuration

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the HCP Terraform organization being managed."
}

variable "hcp_terraform_organization_email" {
  type        = string
  description = "The notification email address for the HCP Terraform organization being managed."
}

variable "backend_project_name" {
  type        = string
  description = "The name of the project used to manage this HCP Terraform organization."
}

variable "backend_workspace_name" {
  type        = string
  description = "The name of the workspace used to manage this HCP Terraform organization."
}

variable "backend_vcs_repository_name" {
  type        = string
  description = "The name of the GitHub repository backing the backend workspace."
}

variable "tfe_provider_authentication_variable_set_name" {
  type        = string
  description = "The name of the variable set used to authenticate the TFE provider."
  default     = "TFE Provider Authentication"
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use in all workspaces."
  default     = "1.10.3"
}

# Organization Configuration

variable "owners_team_emails" {
  type        = set(string)
  description = "A list of member email addresses for the owners team."
  default     = []
}

variable "hcp_terraform_admins_team_name" {
  type        = string
  description = "The name of the team of users who administer the HCP Terraform organization."
  default     = "admins"
}

variable "admins_team_emails" {
  type        = set(string)
  description = "A list of member email addresses for the admins team."
  default     = []
}

# VCS Configuration

variable "github_organization_name" {
  type        = string
  description = "The name of the GitHub organization used as the VCS provider."
}

# Module Configuration

variable "aws_provider_authentication_variable_set_name" {
  type        = string
  description = "The name of the variable set used to authenticate the AWS provider."
  default     = "AWS Provider Authentication"
}

# Lab Infrastructure

variable "vps_relay_workspace_name" {
  type        = string
  description = "The name of the workspace used to manage the lab infrastructure."
}

variable "vps_relay_vcs_repository_name" {
  type        = string
  description = "The name of the GitHub repository backing the vps relay workspace."
}
