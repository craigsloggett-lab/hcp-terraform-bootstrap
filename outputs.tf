output "available_registry_gpg_keys" {
  description = "A list of all of the GPG keys in this organization."
  value       = data.tfe_registry_gpg_keys.all
}
