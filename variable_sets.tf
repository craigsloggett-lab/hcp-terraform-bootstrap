# The resources for the variable set containing authentication for the TFE provider can be found in `bootstrap.tf`.

# AWS Provider Credentials

resource "tfe_variable_set" "aws_provider_authentication" {
  name         = var.aws_provider_authentication_variable_set_name
  description  = "The secrets used to authenticate the AWS Provider."
  organization = tfe_organization.this.name
}

resource "tfe_project_variable_set" "modules" {
  project_id      = tfe_project.modules.id
  variable_set_id = tfe_variable_set.aws_provider_authentication.id
}

# Azure Provider Credentials

resource "tfe_variable_set" "azurerm" {
  name         = var.azurerm_provider_authentication_variable_set_name
  description  = "The secrets used to authenticate the Azure Provider."
  organization = tfe_organization.this.name
}

# Microsoft Fabric Provider Credentials

resource "tfe_variable_set" "fabric" {
  name         = var.fabric_provider_authentication_variable_set_name
  description  = "The secrets used to authenticate the Microsoft Fabric Provider."
  organization = tfe_organization.this.name
}
