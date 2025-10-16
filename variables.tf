# Bootstrap Configuration

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the HCP Terraform organization being managed."
  default     = "craigsloggett-lab"
}

variable "hcp_terraform_organization_email" {
  type        = string
  description = "The notification email address for the HCP Terraform organization being managed."
  default     = "craig.sloggett@hashicorp.com"
}

variable "backend_project_name" {
  type        = string
  description = "The name of the project containing the workspaces used to manage this HCP Terraform organization."
  default     = "Administration"
}

variable "backend_workspace_name" {
  type        = string
  description = "The name of the workspace used to manage this HCP Terraform organization."
  default     = "hcp-terraform-bootstrap"
}

variable "backend_vcs_repository_name" {
  type        = string
  description = "The name of the GitHub repository backing the backend workspace."
  default     = "hcp-terraform-bootstrap"
}

variable "tfe_provider_authentication_variable_set_name" {
  type        = string
  description = "The name of the variable set used to authenticate the TFE provider."
  default     = "TFE Provider Authentication"
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use in all workspaces."
  default     = "1.13.3"
}

# Organization Configuration

variable "owners_team_emails" {
  type        = set(string)
  description = "A list of member email addresses for the owners team."
  default     = ["craig.sloggett@hashicorp.com"]
}

variable "hcp_terraform_admins_team_name" {
  type        = string
  description = "The name of the team of users who administer the HCP Terraform organization."
  default     = "admins"
}

variable "admins_team_emails" {
  type        = set(string)
  description = "A list of member email addresses for the admins team."
  default     = ["craig.sloggett@hashicorp.com"]
}

# VCS Configuration

variable "github_organization_name" {
  type        = string
  description = "The name of the GitHub organization used to configure the VCS provider."
  default     = "craigsloggett-lab"
}
