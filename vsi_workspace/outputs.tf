##############################################################################
# VSI Outputs
##############################################################################

output vsi {
    description = "Provisioned VSIs IDs, subnets and zones."
    value       = [
        for i in ibm_is_instance.vsi:
        {
            id           = i.id,
            zone         = i.zone
            ipv4_address = i.primary_network_interface.0.primary_ipv4_address
        }
    ]
}

output vsi_subnet {
    description = "List of subnets where vsi are provisioned"
    value       = [
        for i in ibm_is_instance.vsi:
        lookup(i.primary_network_interface[0], "id")
    ]
}


##############################################################################
