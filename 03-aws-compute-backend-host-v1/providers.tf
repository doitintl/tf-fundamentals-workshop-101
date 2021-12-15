# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# provider configuration
# https://www.terraform.io/docs/providers/aws/guides/version-2-upgrade.html
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
