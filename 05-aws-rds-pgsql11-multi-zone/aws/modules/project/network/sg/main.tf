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

# --
# @entity/id:    aws_security_group/sec_grp_host_ssh_app_public (public ssh access)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_ssh_app_public" {

  name        = "instance_ssh_public"
  description = "public ssh application security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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
    "Name"     = "${terraform.workspace}-secgrp-ssh-ext"
    "resource" = "SG/SSH/EXT"
  })
}

# --
# @entity/id:    aws_security_group/sec_grp_host_ssh_app_private (public ssh access)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_ssh_app_private" {

  name        = "instance_ssh_private"
  description = "private ssh application security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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
    "Name"     = "${terraform.workspace}-secgrp-ssh-int"
    "resource" = "SG/SSH/INT"
  })
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

# --
# @entity/id:    aws_security_group/sec_grp_host_allow_icmp_ping_public (public icmp/8/0)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/security_group.html
# @source/local: *
# --
resource "aws_security_group" "sec_grp_host_allow_icmp_ping_public" {

  name        = "instance_icmp_ping_public"
  description = "public icmp ping allowance security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.label.tags, {
    "Name"     = "${terraform.workspace}-secgrp-icmp-8-ext"
    "resource" = "SG/ICMP/8/EXT"
  })
}
