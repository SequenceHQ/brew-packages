# Engineering packages
brew "cloudflared"
# brew "colima", restart_service: :changed
# brew "docker"
# brew "docker-credential-helper"

brew "coreutils"
brew "direnv"
brew "gawk"
brew "jq"
brew "mkcert"
brew "mise"
brew "nss"
brew "pgcli"
brew "postgresql" # Do we really want to install Postgres? Or will this run in a docker container?
brew "pre-commit" # This is now part of the mise tools dependencies in the `platform-api` repo & could be removed
brew "watch"
brew "yarn"
brew "yamllint"
brew "yq"
cask "google-cloud-sdk"

# SRE packages
# A lot of these packages would benefit from being managed by mise in a mise.toml in the infastructure repo.
# Terraform and terragrunt could then be consistently upgraded across all developer machines
tap "liamg/tfsec"
brew "terraform"
brew "terragrunt"
brew "terraform-docs"
brew "tflint"
brew "tfsec"
brew "checkov"
# brew "weaveworks/tap/tfctl" # This looks as though it's unmaintained