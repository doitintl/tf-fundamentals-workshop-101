# --
# @todo:         improvements required! we've to use more optionals/variables here
# @entity/id:    vpc (virtual private cloud module used in jenkins/app definition)
# @source/local: https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md
# --
module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = ">2"

  create_vpc = var.enabled

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  default_vpc_enable_dns_support  = true
  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  private_subnet_suffix = "prv"
  public_subnet_suffix  = "pub"

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = var.vpc_private_subnets_natgw_enabled
  enable_vpn_gateway   = false
  enable_dhcp_options  = true

  single_nat_gateway       = true
  one_nat_gateway_per_az   = false
  dhcp_options_domain_name = var.vpc_dhcp_domain_name

  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  private_subnet_tags = var.vpc_private_subnet_tags
  public_subnet_tags  = var.vpc_public_subnet_tags

  tags = {
    env = terraform.workspace
  }
}
