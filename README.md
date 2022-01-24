# Intersight Policies Module

This module creates various pools, policies, a UCS server profile template, and a UCS domain profile. 

 This policy bundle creates the following Intersight server policies:
    - Boot order
    - NTP
    - Network connectivity (dns)
    - Multicast
    - Virtual KVM (enable KVM)
    - Virtual Media
    - System QoS
    - IMC Access
    - LAN connectivity
    - VLAN
    - Port (FI port policy)
    - Ethernet Network Group
    - Ethernet Adapter
    - Ethernet QoS

It also creates an IP pool, MAC pool as well as WWNN, WWPN-A and WWPN-B pools.

# Change the following settings to meet your needs

Go into pools.tf and edit the pools to match what you would like to have in your environment. Otherwise you will end up with the following pools:

- ip-pool from 1.1.1.101 -- 199
- mac-pool from 00:CA:FE:00:00:01 -- 00:CA:FE:00:00:FF
- wwnn-pool from 20:00:00:CA:FE:00:00:01 -- 20:00:00:CA:FE:00:00:FF
- wwpn-a-pool from 20:00:00:CA:FE:0A:00:01 -- 20:00:00:CA:FE:0A:00:FF
- wwpn-b-pool from 20:00:00:CA:FE:0B:00:01 -- 20:00:00:CA:FE:0B:00:FF


### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are used by the the UCS domain profile. To get around this, you will have to delete the domain profile manually and possibly any server profiles that are using any of the profiles or policies created.

This is basically a copy of https://github.com/terraform-cisco-modules/terraform-intersight-policy-bundle with a removal of the policy-diskgroup and addition of the pool creation.