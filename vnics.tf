

resource "intersight_fabric_eth_network_group_policy" "fabric_eth_network_group_policy1" {
  name        = "${var.policy_prefix}-eth-network-group"
  description = var.description
  vlan_settings {
    native_vlan   = var.vnic_native_vlan
    allowed_vlans = join(",", values(var.uplink_vlans_6454))
  }
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_eth_network_control_policy" "fabric_eth_network_control_policy1" {
  name        = "${var.policy_prefix}-eth-network-control"
  description = var.description
  cdp_enabled = true
  forge_mac   = "allow"
  lldp_settings {
    object_type      = "fabric.LldpSettings"
    receive_enabled  = false
    transmit_enabled = false
  }
  mac_registration_mode = "allVlans"
  uplink_fail_action    = "linkDown"
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_vnic_eth_qos_policy" "v_eth_qos1" {
  name           = "${var.policy_prefix}-vnic-eth-qos"
  description    = var.description
  mtu            = 1500
  rate_limit     = 0
  cos            = 0
  burst          = 1024
  priority       = "Best Effort"
  trust_host_cos = false
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# this policy is actually quite complex but we are taking all the defaults
resource "intersight_vnic_eth_adapter_policy" "v_eth_adapter1" {
  name        = "${var.policy_prefix}-vnic-eth-adapter"
  description = var.description
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# =============================================================================
# LAN Connectivity
# -----------------------------------------------------------------------------

resource "intersight_vnic_lan_connectivity_policy" "vnic_lan1" {
  name                = "${var.policy_prefix}-lan-connectivity"
  description         = var.description
  iqn_allocation_type = "None"
  placement_mode      = "auto"
  target_platform     = "FIAttached"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# =============================================================================
# vNICs
# -----------------------------------------------------------------------------
resource "intersight_vnic_eth_if" "eth0" {
  name             = "eth0"
  order            = 0
  failover_enabled = false
  mac_address_type = "POOL"
  depends_on       = [intersight_macpool_pool.macpool_pool1]
  mac_pool {
    #moid = var.vnic_mac_pool
    moid = intersight_macpool_pool.macpool_pool1.moid
  }
  placement {
    id        = ""
    pci_link  = 0
    switch_id = "A"
    uplink    = 0
  }
  cdn {
    value     = "eth0"
    nr_source = "vnic"
  }
  usnic_settings {
    cos      = 5
    nr_count = 0
  }
  vmq_settings {
    enabled             = false
    multi_queue_support = false
    num_interrupts      = 16
    num_vmqs            = 4
  }
  lan_connectivity_policy {
    moid        = intersight_vnic_lan_connectivity_policy.vnic_lan1.id
    object_type = "vnic.LanConnectivityPolicy"
  }
  eth_adapter_policy {
    moid = intersight_vnic_eth_adapter_policy.v_eth_adapter1.id
  }
  eth_qos_policy {
    moid = intersight_vnic_eth_qos_policy.v_eth_qos1.id
  }
  fabric_eth_network_group_policy {
    moid = intersight_fabric_eth_network_group_policy.fabric_eth_network_group_policy1.moid
  }
  fabric_eth_network_control_policy {
    moid = intersight_fabric_eth_network_control_policy.fabric_eth_network_control_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_vnic_eth_if" "eth1" {
  name             = "eth1"
  order            = 0
  failover_enabled = false
  mac_address_type = "POOL"
  depends_on       = [intersight_macpool_pool.macpool_pool1]
  mac_pool {
    #moid = var.vnic_mac_pool
    moid = intersight_macpool_pool.macpool_pool1.moid
  }
  placement {
    id        = ""
    pci_link  = 0
    switch_id = "B"
    uplink    = 0
  }
  cdn {
    value     = "eth1"
    nr_source = "vnic"
  }
  usnic_settings {
    cos      = 5
    nr_count = 0
  }
  vmq_settings {
    enabled             = false
    multi_queue_support = false
    num_interrupts      = 16
    num_vmqs            = 4
  }
  lan_connectivity_policy {
    moid        = intersight_vnic_lan_connectivity_policy.vnic_lan1.id
    object_type = "vnic.LanConnectivityPolicy"
  }
  eth_adapter_policy {
    moid = intersight_vnic_eth_adapter_policy.v_eth_adapter1.id
  }
  eth_qos_policy {
    moid = intersight_vnic_eth_qos_policy.v_eth_qos1.id
  }
  fabric_eth_network_group_policy {
    moid = intersight_fabric_eth_network_group_policy.fabric_eth_network_group_policy1.moid
  }
  fabric_eth_network_control_policy {
    moid = intersight_fabric_eth_network_control_policy.fabric_eth_network_control_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#####
##### ADDED SAN and HBA Parts - Not tested
#####

# vnic FC QoS Policy

resource "intersight_vnic_fc_qos_policy" "v_fc_qos1" {
  name                = "${var.policy_prefix}-fc-qos1"
  description         = var.description
  burst               = 10240
  rate_limit          = 0
  cos                 = 3
  max_data_field_size = 2112
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
    dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# vnic FC Adapter Policy (HBA Adapter Settings)

resource "intersight_vnic_fc_adapter_policy" "fc_adapter" {
  name                = "${var.policy_prefix}-fc-adapter-1"
  description         = var.description
  error_detection_timeout     = 2000
  io_throttle_count           = 256
  lun_count                   = 1024
  lun_queue_depth             = 254
  resource_allocation_timeout = 10000
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  error_recovery_settings {
    enabled           = false
    io_retry_count    = 255
    io_retry_timeout  = 50
    link_down_timeout = 240000
    port_down_timeout = 240000
    object_type       = "vnic.FcErrorRecoverySettings"
  }
  flogi_settings {
    retries     = 8
    timeout     = 4000
    object_type = "vnic.FlogiSettings"
  }
  interrupt_settings {
    mode        = "MSIx"
    object_type = "vnic.FcInterruptSettings"
  }
  plogi_settings {
    retries     = 8
    timeout     = 20000
    object_type = "vnic.PlogiSettings"
  }
  rx_queue_settings {
    ring_size   = 128
    object_type = "vnic.FcQueueSettings"
  }
  tx_queue_settings {
    ring_size   = 128
    object_type = "vnic.FcQueueSettings"
  }
  scsi_queue_settings {
    nr_count    = 8
    ring_size   = 152
    object_type = "vnic.ScsiQueueSettings"
  }
    dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# vnic SAN Connectivity Policy

resource "intersight_vnic_san_connectivity_policy" "vnic_san_con_1" {
  name                = "${var.policy_prefix}-san-connectivity"
  description         = var.description
  target_platform = "FIAttached"
  placement_mode = "auto"
  wwnn_address_type = "POOL"
  wwnn_pool {
    #moid = var.wwnn_pool_moid
    moid = intersight_fcpool_pool.fcpool_pool0.moid
    object_type = "fcpool.Pool"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
    dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# vnic FC Network Policy

resource "intersight_vnic_fc_network_policy" "v_fc_network_a1" {
  name                = "${var.policy_prefix}-fc-network-a1"
  description         = var.description
  vsan_settings {
    #id          = 100
    id = var.san_id_a
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
    dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_vnic_fc_network_policy" "v_fc_network_b1" {
  name                = "${var.policy_prefix}-fc-network-b1"
  description         = var.description
  vsan_settings {
    id          = 200
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
    dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_vnic_fc_if" "fc0" {
   name            = "vhba-a"
   order           = 4
   placement {
     id            = "1"
#     auto_slot_id  = false
     pci_link      = 0
#     auto_pci_link = false
     uplink        = 0
     switch_id     = "A"
     object_type   = "vnic.PlacementSettings"
   }
   persistent_bindings = true
   wwpn_address_type = "POOL"
   wwpn_pool {
     #moid = var.wwpn_pool_a_moid
     moid = intersight_fcpool_pool.fcpool_pool1.moid
     object_type = "fcpool.Pool"
   }
   san_connectivity_policy {
     moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
     object_type = "vnic.SanConnectivityPolicy"
   }
   fc_network_policy {
     moid        = intersight_vnic_fc_network_policy.v_fc_network_a1.moid
     object_type = "vnic.FcNetworkPolicy"
   }
   fc_adapter_policy {
     moid        = intersight_vnic_fc_adapter_policy.fc_adapter.moid
     object_type = "vnic.FcAdapterPolicy"
   }
   fc_qos_policy {
     moid        = intersight_vnic_fc_qos_policy.v_fc_qos1.moid
     object_type = "vnic.FcQosPolicy"
   }
   depends_on = [
     intersight_vnic_san_connectivity_policy.vnic_san_con_1
   ]
   dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
 }

resource "intersight_vnic_fc_if" "fc1" {
   name            = "vhba-b"
   order           = 5
   placement {
     id            = "1"
#     auto_slot_id  = false
     pci_link      = 0
#     auto_pci_link = false
     uplink        = 0
     switch_id     = "B"
     object_type   = "vnic.PlacementSettings"
   }
   persistent_bindings = true
   wwpn_address_type = "POOL"
   wwpn_pool {
     #moid = var.wwpn_pool_b_moid
     moid = intersight_fcpool_pool.fcpool_pool2.moid
     object_type = "fcpool.Pool"
   }
   san_connectivity_policy {
     moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
     object_type = "vnic.SanConnectivityPolicy"
   }
   fc_network_policy {
     moid        = intersight_vnic_fc_network_policy.v_fc_network_b1.moid
     object_type = "vnic.FcNetworkPolicy"
   }
   fc_adapter_policy {
     moid        = intersight_vnic_fc_adapter_policy.fc_adapter.moid
     object_type = "vnic.FcAdapterPolicy"
   }
   fc_qos_policy {
     moid        = intersight_vnic_fc_qos_policy.v_fc_qos1.moid
     object_type = "vnic.FcQosPolicy"
   }

   depends_on = [
     intersight_vnic_san_connectivity_policy.vnic_san_con_1
   ]
   dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
 }
