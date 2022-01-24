# Change the following settings to meet your needs

Go into pools.tf and edit the pools to match what you would like to have in your environment. Otherwise you will end up with the following pools:

ip-pool from 1.1.1.101 -- 199
mac-pool from 00:CA:FE:00:00:01 -- 00:CA:FE:00:00:FF
wwnn-pool from 20:00:00:CA:FE:00:00:01 -- 20:00:00:CA:FE:00:00:FF
wwpn-a-pool from 20:00:00:CA:FE:0A:00:01 -- 20:00:00:CA:FE:0A:00:FF
wwpn-b-pool from 20:00:00:CA:FE:0B:00:01 -- 20:00:00:CA:FE:0B:00:FF


# Intersight Policies Module

This module simplifies the creation of basic server and domain policies in the specified Intersight organization. It takes very few inputs and creates more than 20 policies with common settings. It also creates a server profile template and UCS domain profile that use several of the policies. 

This module is intended to give users a jump-start into creating their own policies but will not represent the exact policy that every user will want. The policies can be updated manually or just used a reference to create new policies.

### Note about Terraform destroy
This module creates various pools, policies, a UCS server profile template, and a UCS domain profile. 

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are used by the the UCS domain profile. To get around this, you will have to delete the domain profile manually and possibly any server profiles that are using any of the profiles or policies created.

This is basically a copy of https://github.com/terraform-cisco-modules/terraform-intersight-policy-bundle with a removal of the policy-diskgroup and addition of the pool creation.