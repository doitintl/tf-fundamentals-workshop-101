output "tt_ec2_backend_asg_id" {
  description = "The autoscaling group id of our backend host definition"
  value       = module.doit_svc_compute_ec2_backend_centos_9.autoscaling_group_id
}
