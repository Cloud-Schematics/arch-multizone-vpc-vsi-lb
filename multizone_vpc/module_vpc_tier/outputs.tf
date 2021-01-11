##############################################################################
# Outputs
##############################################################################

output subnet_ids {
  description = "IDs of subnets created for this tier"
  value       = ibm_is_subnet.subnet.*.id
}

output zones {
  description = "A list of unique zones where the subnets are provisioned"
  value       = distinct(ibm_is_subnet.subnet.*.zone)
}

output cidr_blocks {
  value       = ibm_is_subnet.subnet.*.ipv4_cidr_block
}

##############################################################################