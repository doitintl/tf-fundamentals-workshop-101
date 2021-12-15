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

module "doit_svc_compute_ec2_backend_centos_7" {

  source = "../../../global/services/ec2-asg"

  namespace = var.namespace
  stage     = var.stage

  image_id                  = var.set_instance_ami_id_centos_9
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

  user_data_base64             = base64encode(local.backend_user_data)
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
# LOCALS
# Used to represent any data that requires complex expressions/interpolations
# ---------------------------------------------------------------------------------------------------------------------

locals {
  backend_user_data = <<-USERDATA
    #!/bin/bash
    yum update && \
    cd /tmp ;
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    hostnamectl set-hostname doit-ec2-backend-${var.set_instance_grp_num}
  USERDATA
}

/*
    yum upgrade -y && \
    yum -y install mc curl wget git && \
    yum clean all ;
*/