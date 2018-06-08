variable "namespace" {
  description = "Namespace, which could be your organization name, e.g. `cp` or `cloudposse`"
}

variable "stage" {
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`"
}

variable "name" {
  description = "Solution name, e.g. `app`"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `name`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map(`BusinessUnit`,`XYZ`)"
}

variable "priority" {
  type    = "string"
  default = "100"
}

variable "port" {
  type  = "string"
  value = "80"
}

variable "protocol" {
  type  = "string"
  value = "HTTP"
}

variable "target_type" {
  type    = "string"
  default = "ip"
}

variable "vpc_id" {
  type = "string"
}

variable "hosts" {
  type  = "list"
  value = ["*"]
}

variable "paths" {
  type  = "list"
  value = ["/*"]
}
