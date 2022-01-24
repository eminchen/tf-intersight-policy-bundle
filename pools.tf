resource "intersight_ippool_pool" "ippool_pool1" {
  name = "${var.policy_prefix}-pool1"
  description = "ippool pool"
  assignment_order = "sequential"
  ip_v4_blocks {
    from = "1.1.1.101"
    size = "99"
  }

  ip_v4_config {
    moid = var.ippool_ip_v4_config
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
 