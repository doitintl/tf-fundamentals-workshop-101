output "tt_ec2_bastion_asg_id" {
  description = "The autoscaling group id of our bastion host definition"
  value       = module.doit_svc_compute_ec2_bastion_ubuntu_20_04.autoscaling_group_id
}
