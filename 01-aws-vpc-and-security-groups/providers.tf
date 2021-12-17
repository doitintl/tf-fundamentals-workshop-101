# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# provider configuration
# https://www.terraform.io/language/providers/configuration
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
