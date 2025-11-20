output "tfe_organization_configuration" {
  value       = module.terraform_tfe_bootstrap.tfe_organization_configuration
  description = "The configuration for the HCP Terraform organization."
}
