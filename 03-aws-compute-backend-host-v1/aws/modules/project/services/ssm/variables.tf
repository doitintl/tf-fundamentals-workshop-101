variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'web-app'"
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

variable "init_project_name" {
  type        = string
  description = "The project name"
}

variable "init_project_namespace" {
  type        = string
  description = "The project namespace"
}
