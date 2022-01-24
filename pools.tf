resource "intersight_ippool_pool" "ippool_pool1" {
  name = "${var.policy_prefix}-ip-pool"
  description = var.description
  assignment_order = "sequential"
  ip_v4_blocks {
    from = "1.1.1.101"
    size = "99"
  }
  ip_v4_config {
    object_type = "ippool.IpV4Config"
    gateway = "1.1.1.1"
    netmask = "255.255.255.0"
    primary_dns = "8.8.8.8"
    }
  organization {
      object_type = "organization.Organization"
      moid = var.organization
      }
}

resource "intersight_macpool_pool" "macpool_pool1" {
  name = "${var.policy_prefix}-mac-pool"
  description = var.description
  assignment_order = "sequential"
  mac_blocks {
    object_type = "macpool.Block"
    from        = "00:CA:FE:00:00:01"
    size          = "255"
    }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
}

resource "intersight_fcpool_pool" "fcpool_pool1" {
  name = "${var.policy_prefix}-wwnn-pool"
  description = var.description
  assignment_order = "sequential"
  id_blocks {
    object_type = "fcpool.Block"
    from        = "20:00:00:CA:FE:00:00:01"
    size          = "255"
    }
  pool_pool_purpose = "wwpn"
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
}
 