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
# @entity/id:    aws_security_group/sec_grp_host_web_app_private (internal http/https-apps)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_web_app_private" {

  name        = "instance_www_private"
  description = "private web application security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    "Name"     = "${terraform.workspace}-secgrp-web-int"
    "resource" = "SG/WEB/INT"
  })
}

# --
# @entity/id:    aws_security_group/sec_grp_host_web_app_public (public http/https-apps)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_web_app_public" {

  name        = "instance_www_public"
  description = "public web application security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.label.tags, {
    "Name"     = "${terraform.workspace}-secgrp-web-ext"
    "resource" = "SG/WEB/EXT"
  })
}

