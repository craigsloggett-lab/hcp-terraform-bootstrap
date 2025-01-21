locals {
  imports = {
    organization_membership_ids = {
      "craig.sloggett@hashicorp.com"                           = "ou-tSVPjvXHB4iTqcPb"
      "doormat@hashicorp.com"                                  = "ou-9KRr8gq4h6JikktE"
      "api-org-craigsloggett-lab-xqsus22ynh@hashicorp.com"     = "ou-EhS6WkPBDVPxYYqd"
      "api-team_1202828@hashicorp.com"                         = "ou-mLy6EZTkP2bKW9w3"
      "gh-webhooks-craigsloggett-lab-db12onjulf@hashicorp.com" = "ou-j7QUTL6CcJUktJJC"
    }
    project_ids = {
      default_project = "prj-1ifijXyay7xeH9Zc"
      platform_team   = "prj-qW7NitPW1R49WN4b"
    }
    workspace_ids = {
      hcp_terraform_admin = "ws-aAUcuGF6QEJKuQyL"
    }
    variable_set_ids = {
      tfe_provider_authentication = "varset-FwFGK65suTr7eaAA"
    }
  }
}
