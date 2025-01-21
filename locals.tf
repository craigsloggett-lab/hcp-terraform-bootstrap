locals {
  imports = {
    teams = {
      owners = {
        id = "team-p9ryLNrpQ9TNmEFh"
        members = {
          craigsloggett = {
            email                      = "craig.sloggett@hashicorp.com"
            organization_membership_id = "ou-tSVPjvXHB4iTqcPb"
          }
          doormat-at-hashicorp_com = {
            email                      = "doormat@hashicorp.com"
            organization_membership_id = "ou-9KRr8gq4h6JikktE"
          }
          api-org-craigsloggett-lab-xqsuS22ynH = {
            email                      = "api-org-craigsloggett-lab-xqsus22ynh@hashicorp.com"
            organization_membership_id = "ou-EhS6WkPBDVPxYYqd"
          }
          api-team_1202828 = {
            email                      = "api-team_1202828@hashicorp.com"
            organization_membership_id = "ou-mLy6EZTkP2bKW9w3"
          }
          gh-webhooks-craigsloggett-lab-dB12ONJulF = {
            email                      = "gh-webhooks-craigsloggett-lab-db12onjulf@hashicorp.com"
            organization_membership_id = "ou-j7QUTL6CcJUktJJC"
          }
        }
      }
    }
    projects = {
      default_project = {
        id = "prj-1ifijXyay7xeH9Zc"
      }
      platform_team = {
        id = "prj-qW7NitPW1R49WN4b"
      }
    }
    workspaces = {
      hcp_terraform_admin = {
        id = "ws-aAUcuGF6QEJKuQyL"
      }
    }
    variable_sets = {
      tfe_provider_authentication = {
        id   = "varset-FwFGK65suTr7eaAA"
        name = "TFE Provider Authentication"
      }
    }
  }
  # TODO: Move this to variables.
  admins = toset([
    "craig.sloggett@hashicorp.com",
  ])
}
