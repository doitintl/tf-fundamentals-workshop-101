
output "sec_grp_host_ssh_app_public" {
  value = aws_security_group.sec_grp_host_ssh_app_public.id
}

output "sec_grp_host_web_app_public" {
  value = aws_security_group.sec_grp_host_web_app_public.id
}

output "sec_grp_host_web_app_private" {
  value = aws_security_group.sec_grp_host_web_app_private.id
}

output "sec_grp_host_allow_icmp_ping_public" {
  value = aws_security_group.sec_grp_host_allow_icmp_ping_public.id
}
