
output "sec_grp_host_webapp" {
  value = aws_security_group.sec_grp_host_web_app_private.id
}

output "sec_grp_host_datadog_default" {
  value = aws_security_group.sec_grp_host_web_app_public.id
}
