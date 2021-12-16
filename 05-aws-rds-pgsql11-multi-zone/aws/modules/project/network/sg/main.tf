# --
# @entity/id:    label (label, global/core/label)
# @source/doc:   https://github.com/cloudposse/terraform-null-label/blob/master/README.md
# @source/local: aws/modules/global/network/vpc/main.tf
# @info:         this is an adaption of core-label open source repository used for tag/lbl ident of resources
# --
module "label" {

  source = "../../../global/core/label"

  stage     = var.stage
  namespace = var.namespace
  name      = var.name

  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

# --
# @entity/id:    aws_security_group/sec_grp_host_postgresql_private (postgresql)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_postgresql_private" {

  name        = "instance_rds_postgresql_private"
  description = "rds postgresql security group (private)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.label.tags, {
    "Name"     = "${terraform.workspace}-secgrp-rds-postgresql-int"
    "resource" = "SG/RDS/PGSQL/INT"
  })
}
