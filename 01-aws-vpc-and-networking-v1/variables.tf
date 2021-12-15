# ---------------------------------------------------------------------------------------------------------------------
# CORE PARAMETERS
# These parameters will be handled by a corresponding tfvars-file
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "the aws region used during our terraform process calls"
}

variable "aws_profile" {
  description = "the aws profile used during our terraform process calls"
}

# ---------------------------------------------------------------------------------------------------------------------
# INIT PARAMETERS
# These parameters should have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "init_name" {
  default     = "aws-tf-lab-01"
  description = "the initial name for this stack used within all modules as basic tag/label source"
}

variable "init_name_long" {
  default     = "aws-vpc-net-example-lab-01"
  description = "the initial name for this stack used within all modules as basic tag/label source"
}

variable "init_namespace" {
  default     = "doit"
  description = "the initial namespace for this stack used within all modules as basic tag/label source"
}

# ---------------------------------------------------------------------------------------------------------------------
# INFRASTRUCTURE PARAMETERS (project related configuration)
# These parameters should have reasonable defaults otherwise a corresponding tfvars-file is required
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_cidr_region" {
  description = "The Top-Level VPC CIDR to use for our AWS region (used in local.vpc_cidr[prod/stage/test])"
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA BLOCK
# remote state variable output/input handling
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

# ---------------------------------------------------------------------------------------------------------------------
# LOCALS BLOCK
# module related local variable binding block
# ---------------------------------------------------------------------------------------------------------------------

locals {

  # this variable will be used to define our workspace based environment CIDR ranges for prod, stage and test
  # --
  vpc_cidr_app = {

    prod  = cidrsubnet(var.vpc_cidr_region, 8, 0)
    stage = cidrsubnet(var.vpc_cidr_region, 8, 1)
    test  = cidrsubnet(var.vpc_cidr_region, 8, 2)
  }
}
