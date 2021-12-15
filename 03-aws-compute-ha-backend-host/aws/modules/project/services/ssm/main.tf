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
module "label" {

  source = "../../../global/core/label"

  stage     = var.stage
  namespace = var.namespace
  name      = var.name

  attributes = var.attributes
  tags       = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCES
# some native resources used in this infrastructure approach
# ---------------------------------------------------------------------------------------------------------------------

# --
# @entity/id:    aws_ssm_parameter/val_project_name
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html
# @info:         this is just an example k/v definition (saving our sandbox rand-id variable in ssm-ps)
# --
resource "aws_ssm_parameter" "val_project_name" {

  name        = "kv-${var.init_project_name}-project-name"
  type        = "String"
  description = "primary (naming) identifier for this project"
  value       = var.init_project_name

  tags = module.label.tags
}

# --
# @entity/id:    aws_ssm_parameter/val_project_namespace
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html
# @info:         this is just an example k/v definition (saving our sandbox rand-id variable in ssm-ps)
# --
resource "aws_ssm_parameter" "val_project_namespace" {

  name        = "kv-${var.init_project_name}-project-namespace"
  type        = "String"
  description = "secondary (namespace) identifier for this project"
  value       = var.init_project_namespace

  tags = module.label.tags
}