variable "namespace" {
  type        = string
  description = "Namespace (_e.g._ `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (_e.g._ `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name (_e.g._ `app`)"
}

variable "delimiter" {
  type        = string
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
  default     = "-"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (e.g. `1`)"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}

variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "vpc_cidr" {
  description = "The (VPC) CIDR to use for an optional SecurityGroup encapsulation"
  default     = "0.0.0.0/0"
}

variable "vpc_id" {
  description = "The VPC ID to use our SecurityGroup bound"
}
