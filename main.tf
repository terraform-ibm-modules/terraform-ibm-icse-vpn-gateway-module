##############################################################################
# VPN Gateway
##############################################################################

resource "ibm_is_vpn_gateway" "gateway" {
  count          = var.vpn_gateway.use_vpn_gateway && var.vpc_id != null ? 1 : 0
  name           = "${var.prefix}-${var.vpn_gateway.name}"
  subnet         = var.subnet_id
  mode           = var.vpn_gateway.mode
  resource_group = var.resource_group_id
  tags           = var.tags

  timeouts {
    delete = "1h"
  }
}

##############################################################################


##############################################################################
# Create Map of Connections
##############################################################################

module "vpn_gateway_connection_map" {
  source = "./list_to_map"
  list = var.vpc_id == null ? [] : [
    for connection in(var.vpn_gateway.connections == null ? [] : var.vpn_gateway.connections) :
    merge(connection, {
      name = "${var.prefix}-${var.vpn_gateway.name}-${index(var.vpn_gateway.connections, connection) + 1}"
    })
  ]
}

##############################################################################


##############################################################################
# Create Connections
##############################################################################

resource "ibm_is_vpn_gateway_connection" "gateway_connection" {
  for_each       = var.vpn_gateway.use_vpn_gateway == true && var.vpn_gateway.connections != null ? module.vpn_gateway_connection_map.value : {}
  name           = each.value.name
  vpn_gateway    = var.vpn_gateway.use_vpn_gateway == true && var.vpn_gateway.connections != null ? ibm_is_vpn_gateway.gateway[0].id : null
  peer_address   = each.value.peer_address
  preshared_key  = each.value.preshared_key
  local_cidrs    = each.value.local_cidrs
  peer_cidrs     = each.value.peer_cidrs
  admin_state_up = each.value.admin_state_up
}

##############################################################################
