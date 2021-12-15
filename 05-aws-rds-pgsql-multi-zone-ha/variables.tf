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

variable "rds_db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
}

variable "rds_db_user" {
  type        = string
  sensitive   = true
  description = "Username for the master DB user"
}

variable "rds_db_pwd" {
  type        = string
  sensitive   = true
  description = "Password for the master DB user"
}

variable "rds_db_port" {
  type        = number
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
}

variable "rds_db_subnet_group_name" {
  type        = string
  default     = null
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`"
}

variable "rds_db_parameter_group" {
  type        = string
  description = "Parameter group, depends on DB engine used"
}

variable "rds_sys_deletion_protection" {
  type        = bool
  description = "Set to true to enable deletion protection on the RDS instance"
}

variable "rds_sys_multi_az" {
  type        = bool
  description = "Set to true if multi AZ deployment must be supported"
}

variable "rds_sys_az" {
  type        = string
  default     = null
  description = "The AZ for the RDS instance. Specify one of `subnet_ids`, `db_subnet_group_name` or `availability_zone`. If `availability_zone` is provided, the instance will be placed into the default VPC or EC2 Classic"
}

variable "rds_sys_storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
}

variable "rds_sys_storage_encrypted" {
  type        = bool
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
}

variable "rds_sys_allocated_storage" {
  type        = number
  description = "The allocated storage in GBs"
}

variable "rds_sys_engine" {
  type        = string
  description = "Database engine type"
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
}

variable "rds_sys_engine_version" {
  type        = string
  description = "Database engine version, depends on engine type"
  # http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
}

variable "rds_sys_major_engine_version" {
  type        = string
  description = "Database MAJOR engine version, depends on engine type"
  # https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html
}

variable "rds_sys_instance_class" {
  type        = string
  description = "Class of RDS instance"
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
}

variable "rds_sys_publicly_accessible" {
  type        = bool
  description = "Determines if database can be publicly available (NOT recommended)"
}

variable "rds_sys_apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
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
