##############################################################################
# Account Variables
##############################################################################

variable "prefix" {
  description = "A unique identifier for resources. Must begin with a letter and end with a letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
  default     = "icse"

  validation {
    error_message = "Prefix must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([A-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "resource_group_id" {
  description = "ID of the resource group where gateway will be provisioned"
  type        = string
  default     = null
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}


##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_id" {
  description = "ID of the VPC where the gateway will be created"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID of the subnet where the gateway will be created"
  type        = string
  default     = null
}

##############################################################################

##############################################################################
# VPN Gateways
##############################################################################

variable "vpn_gateway" {
  description = "VPN Gateways to create."
  type = object({
    use_vpn_gateway = bool             # create vpn gateway
    name            = optional(string) # gateway name
    mode            = optional(string) # Can be `route` or `policy`. Default is `route`
    connections = optional(list(
      object({
        peer_address   = string
        preshared_key  = string
        local_cidrs    = optional(list(string))
        peer_cidrs     = optional(list(string))
        admin_state_up = optional(bool)
      })
    ))
  })

  default = {
    use_vpn_gateway = true
    name            = "vpn-gateway"
    subnet_name     = "subnet-a"
    connections     = []
  }
}

##############################################################################
