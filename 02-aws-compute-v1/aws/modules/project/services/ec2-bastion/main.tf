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

  attributes = var.attributes
  tags       = var.tags
}

module "doit_svc_compute_ec2_bastion_ubuntu_20_04" {

  source = "../../../global/services/ec2-asg"

  namespace = var.namespace
  stage     = var.stage

  image_id                  = data.aws_ami.ubuntu_linux_20_04.id
  instance_type             = var.set_instance_type
  security_group_ids        = var.set_security_groups
  subnet_ids                = var.set_subnets_app
  iam_instance_profile_name = var.set_iam_instance_profile

  min_size                    = var.set_size_min
  max_size                    = var.set_size_max
  desired_capacity            = var.set_size_desired
  health_check_type           = "EC2"
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = true

  user_data_base64             = base64encode(local.bastion_user_data)
  autoscaling_policies_enabled = false
  protect_from_scale_in        = false
  asg_name_prefix              = var.set_asg_name_prefix

  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.set_root_volume_size
        volume_type           = var.set_root_volume_type
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
      }
    }
  ]

  tags = module.label.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA
# Used to represent any data that requires complex filter mechanics (e.g. find some AMIs)
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu_linux_20_04" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


# https://www.terraform.io/docs/configuration/expressions.html#string-literals
locals {
  bastion_user_data = <<-USERDATA
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install mc curl wget git apt-transport-https ca-certificates && \
    hostnamectl set-hostname doit-ec2-bastion-${var.set_instance_grp_num}
  USERDATA
}