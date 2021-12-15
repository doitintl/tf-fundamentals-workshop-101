variable "vpc_azs" {
  description = "The regions that will be uses for our vpc"
  default     = []
}

variable "vpc_cidr" {
  description = "The CIDR block used for our vpc"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "The unique name used for our vpc"
  type        = string
  default     = ""
}

variable "vpc_dhcp_domain_name" {
  description = "The dhcp option domain name used for our vpc"
  type        = string
  default     = ""
}

variable "vpc_private_subnets" {
  description = "The list of private subnets used within this vpc"
  default     = []
}

variable "vpc_public_subnets" {
  description = "The list of private subnets used within this vpc"
  default     = []
}

variable "vpc_private_subnets_natgw_enabled" {
  description = "activate nat gateway for all private subnets (if true)"
  default     = false
  type        = bool
}

variable "enabled" {
  description = "activate build process for this module (default 'true')"
  default     = true
  type        = bool
}

variable "vpc_private_subnet_tags" {
  type        = map(string)
  description = "Additional private subnet tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}

variable "vpc_public_subnet_tags" {
  type        = map(string)
  description = "Additional public subnet tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}