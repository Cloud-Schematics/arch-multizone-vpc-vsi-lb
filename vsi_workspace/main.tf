##############################################################################
# Create Subnets
##############################################################################

data ibm_is_subnet subnet {
  count      = length(var.subnet_ids)

  identifier = var.subnet_ids[count.index]
}

##############################################################################