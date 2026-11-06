variable "instance_env" {
  type        = string
  default     = "Production"
  description = "The environment the instance belongs to"
}

variable "security_group_id" {
    type = string
    description = "SG ID"
}

variable "subnet_id" {
    type = string
    description = "Subnet ID"
}