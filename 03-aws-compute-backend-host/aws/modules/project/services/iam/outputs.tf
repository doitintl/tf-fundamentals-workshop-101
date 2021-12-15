output "app_ec2_iam_profile" {
  description = "The default (IAM) instance profile"
  value       = aws_iam_instance_profile.ec2_default_profile.name
}
