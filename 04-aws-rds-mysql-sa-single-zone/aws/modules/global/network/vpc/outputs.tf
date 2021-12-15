# ---------------------------------------------------------------------------------------------------------------------
# MODULE OUTPUT
# some basic module output, feel free to extend - you can take a look into vendor module output on link down below
# @link: https://github.com/terraform-aws-modules/terraform-aws-vpc#outputs
# ---------------------------------------------------------------------------------------------------------------------

output "default_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.vpc.default_route_table_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# ---------------------------------------------------------------------------------------------------------------------
# TERRATEST OUTPUT
# some dedicated output for our terraTest realted checks
# ---------------------------------------------------------------------------------------------------------------------

output "default_vpc_name" {
  description = "The name of the VPC (used for terraTest)"
  value       = module.vpc.name
}
