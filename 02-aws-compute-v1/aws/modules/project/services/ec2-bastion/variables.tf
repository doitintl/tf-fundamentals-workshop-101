variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name, e.g. 'bf' or 'blackfrog'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit', 'XYZ')`"
}

variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "set_subnets_app" {
  description = "usable (private or public) subnets for this ASG"
  type        = list(string)
}

variable "set_security_groups" {
  description = "active security groups for this ASG"
  type        = list(string)
}

variable "set_root_volume_type" {
  type        = string
  description = "desired instance root volume type"
}

variable "set_root_volume_size" {
  type        = number
  description = "desired instance root volume size"
}

variable "set_associate_public_ip_address" {
  type        = bool
  description = "Set to false to prevent public ip association to corresponding asg instance"
  default     = true
}

variable "set_instance_type" {
  type        = string
  description = "desired instance type"
}

variable "set_iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type        = string
  default     = ""
}

variable "set_size_desired" {
  type        = string
  description = "desired instance capacity (size)"
}

variable "set_size_min" {
  type        = string
  description = "min instance capacity (scale)"
}

variable "set_size_max" {
  type        = string
  description = "max instance capacity (scale)"
}

variable "set_asg_name_prefix" {
  type        = string
  description = "name-prefix for auto scaling group"
}

#
# instance-grp-id (num)
# --
variable "set_instance_grp_num" {
  default     = "1"
  description = "instance group id (numeric)"
}
