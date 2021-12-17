# ---------------------------------------------------------------------------------------------------------------------
# MODULES
# some modules used in this infrastructure approach
# ---------------------------------------------------------------------------------------------------------------------

# --
# @entity/id:    core_label (label, global/core/label)
# @source/doc:   https://github.com/cloudposse/terraform-null-label/blob/master/README.md
# @source/local: aws/modules/global/network/vpc/main.tf
# @info:         this is an adaption of core-label open source repository used for tag/lbl ident of resources
# --
module "core_label" {

  source = "./aws/modules/global/core/label"

  stage     = terraform.workspace
  namespace = var.init_namespace
  name      = var.init_name

  tags = {

    project_env       = terraform.workspace
    project_app       = var.init_name
    project_app_long  = var.init_name_long
    project_namespace = var.init_namespace

    businessUnit = "DevOps"
    businessCorp = "DoiT"

    is_stable     = "true"
    is_public     = "false"
    is_internal   = "true"
    is_managed    = "true"
    is_managed_by = "terraform_1_0_n"
  }

  delimiter  = "-"
  attributes = []
}

# --
# @entity/id:    doit_core_vpc
# @source/doc:   https://github.com/terraform-aws-modules/terraform-aws-vpc
# @source/local: aws/modules/global/network/vpc/main.tf
# @info:         this vpc will only be created on local/sandbox environment (workspace=test)
#                do not put any labels or tags at this resource - the vpc module creates its own tags (!)
# --
module "doit_core_vpc" {

  enabled = true

  source = "./aws/modules/global/network/vpc"

  vpc_name             = "${module.core_label.stage}-${module.core_label.namespace}-${module.core_label.name}-vpc"
  vpc_dhcp_domain_name = "${terraform.workspace}.${module.core_label.name}.workshop.doit.local"

  vpc_azs  = data.aws_availability_zones.available.names
  vpc_cidr = local.vpc_cidr

  vpc_private_subnets_natgw_enabled = false
  vpc_private_subnet_tags           = merge(module.core_label.tags, { "Name" = "${module.core_label.stage}-${module.core_label.namespace}-${module.core_label.name}-sn-private", "tf_resource" = "SN_PRIV" })
  vpc_private_subnets = [
    cidrsubnet(local.vpc_cidr, 4, 0), // --| used for private apps
    cidrsubnet(local.vpc_cidr, 4, 1), // --|----------------------'
    cidrsubnet(local.vpc_cidr, 4, 2), // --'
  ]
}

# --
# @entity/id:    doit_core_sec_groups
# @source/local: aws/modules/global/network/sg/main.tf
# --
module "doit_core_sec_groups" {

  enabled = true

  source = "./aws/modules/project/network/sg"

  stage     = module.core_label.stage
  namespace = module.core_label.namespace
  name      = module.core_label.name

  vpc_id   = local.vpc_id
  vpc_cidr = local.vpc_cidr

  attributes = module.core_label.attributes
  tags = merge(module.core_label.tags, {
    "tf_resource" = "SG"
  })
}

# --
# @entity/id:    doit_core_ssm
# @source/local: aws/modules/global/services/ssm/main.tf
# --
module "doit_core_ssm" {

  enabled = true

  source = "./aws/modules/project/services/ssm"

  stage     = module.core_label.stage
  namespace = module.core_label.namespace
  name      = module.core_label.name

  init_project_name      = var.init_name
  init_project_namespace = var.init_namespace

  attributes = module.core_label.attributes
  tags = merge(module.core_label.tags, {
    "tf_resource" = "SSM"
  })
}

# --
# @entity/id:    doit_core_rds_postgresql_private
# @source/local: aws/modules/project/service/rds/main.tf
# --
module "doit_core_rds_postgresql_private" {

  enabled = true

  source = "./aws/modules/project/services/rds"

  stage     = module.core_label.stage
  namespace = module.core_label.namespace
  name      = module.core_label.name

  vpc_id     = local.vpc_id
  subnet_ids = local.vpc_subnet_ids_priv

  database_name        = var.rds_db_name
  database_user        = var.rds_db_user
  database_password    = var.rds_db_pwd
  database_port        = var.rds_db_port
  db_parameter_group   = var.rds_db_parameter_group
  db_subnet_group_name = var.rds_db_subnet_group_name

  multi_az            = var.rds_sys_multi_az
  storage_type        = var.rds_sys_storage_type
  allocated_storage   = var.rds_sys_allocated_storage
  storage_encrypted   = var.rds_sys_storage_encrypted
  engine              = var.rds_sys_engine
  engine_version      = var.rds_sys_engine_version
  instance_class      = var.rds_sys_instance_class
  publicly_accessible = var.rds_sys_publicly_accessible
  apply_immediately   = var.rds_sys_apply_immediately
  availability_zone   = var.rds_sys_az

  security_group_ids = [
    module.doit_core_sec_groups.sec_grp_host_postgresql_private
  ]

  db_parameter = [
    {
      name         = "autovacuum"
      value        = 1
      apply_method = "immediate"
    },
    {
      name         = "client_encoding"
      value        = "utf8"
      apply_method = "immediate"
    }
  ]

  attributes = module.core_label.attributes
  tags = merge(module.core_label.tags, {
    "tf_resource" = "RDS/DB/postgresql/INT"
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# LOCALS
# Used to represent any data that requires complex expressions/interpolations
# ---------------------------------------------------------------------------------------------------------------------

locals {

  // @info: use dedicated CIDR for local/sandbox 'test' environments you can use remote-state based config also
  vpc_cidr            = local.vpc_cidr_app[terraform.workspace]
  vpc_id              = module.doit_core_vpc.default_vpc_id
  vpc_subnet_ids_priv = module.doit_core_vpc.private_subnets
  vpc_subnet_ids_pub  = module.doit_core_vpc.public_subnets

  // @info: try to fetch aws meta data from variables, use data information as fallback
  aws_account_id = data.aws_caller_identity.default.account_id
  aws_region     = signum(length(var.aws_region)) == 1 ? var.aws_region : data.aws_region.default.name
  aws_profile    = var.aws_profile
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA
# Used to represent any data that requires complex filter mechanics (e.g. find some AMIs)
# ---------------------------------------------------------------------------------------------------------------------
#
# -/-
#
