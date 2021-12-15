output "tt_vpc_primary_name" {
  description = "The name of our primary VPC (used for terraTest)"
  value       = module.doit_core_vpc.default_vpc_name
}

output "tt_vpc_primary_id" {
  description = "The id of our primary VPC (used for terraTest)"
  value       = module.doit_core_vpc.default_vpc_id
}

output "tt_vpc_subnets_private" {
  description = "The private subnets of our primary VPC (used for terraTest)"
  value       = module.doit_core_vpc.private_subnets
}

output "tt_vpc_subnets_public" {
  description = "The public subnets of our primary VPC (used for terraTest)"
  value       = module.doit_core_vpc.public_subnets
}
