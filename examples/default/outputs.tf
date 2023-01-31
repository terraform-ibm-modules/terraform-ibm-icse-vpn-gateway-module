##############################################################################
# VPN Gateway Outputs
##############################################################################

output "vpn_gateway" {
  description = "VPN Gateway information"
  value       = var.vpc_id == null ? null : var.vpn_gateway.use_vpn_gateway == true && var.vpn_gateway.connections != null ? ibm_is_vpn_gateway.gateway[0] : null
}

##############################################################################
