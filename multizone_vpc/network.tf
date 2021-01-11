
##############################################################################
# Create an  ACL for ingress/egress used by  all subnets in VPC
##############################################################################

locals {
      # Allow all traffic from peer subnets
      # allow_subnet_cidr_rules = [
      #       for i in var.cidr_blocks:
      #       {
      #             name        = "allow-traffic-subnet-${index(var.cidr_blocks, i) + 1}"
      #             action      = "allow"
      #             source      = i
      #             destination = "0.0.0.0/0"
      #             direction   = "inbound"
      #       }
      # ]
      acl_rules = flatten(
            [
                  # local.allow_subnet_cidr_rules,
                  var.acl_rules
            ]
      )
}

resource ibm_is_network_acl multizone_acl {
      name           = "${var.unique_id}-acl"
      vpc            = ibm_is_vpc.vpc.id
      resource_group = var.resource_group_id

      # Create ACL rules
      dynamic rules {
            for_each = local.acl_rules
            content {
                  name        = rules.value.name
                  action      = rules.value.action
                  source      = rules.value.source
                  destination = rules.value.destination
                  direction   = rules.value.direction

                  ##############################################################################
                  # Dynamically create TCP rules
                  ##############################################################################

                  dynamic tcp {

                        # Runs a for each loop, if the rule block contains tcp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "tcp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has tcp
                        content {

                              port_min = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "port_min"
                              )

                              port_max = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "port_max"
                              )

                              source_port_min = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "source_port_min"
                              )

                              source_port_max = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "source_port_max"
                              )
                        }
                  } 

                  ##############################################################################

                  ##############################################################################
                  # Dynamically create UDP rules
                  ##############################################################################

                  dynamic udp {

                        # Runs a for each loop, if the rule block contains tcp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "udp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has udp
                        content {

                              port_min = lookup(
                                    lookup(
                                          rules.value, 
                                          "udp"
                                    ), 
                                    "port_min"
                              )

                              port_max = lookup(
                                    lookup(
                                          rules.value, 
                                          "udp"
                                    ), 
                                    "port_max"
                              )
                              
                              source_port_min = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "source_port_min"
                              )

                              source_port_max = lookup(
                                    lookup(
                                          rules.value, 
                                          "tcp"
                                    ), 
                                    "source_port_max"
                              )
                        }
                  } 

                  ##############################################################################

                  ##############################################################################
                  # Dynamically create ICMP rules
                  ##############################################################################

                  dynamic icmp {

                        # Runs a for each loop, if the rule block contains icmp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "icmp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has icmp
                        content {

                              type = lookup(
                                    lookup(
                                          rules.value, 
                                          "icmp"
                                    ), 
                                    "type"
                              )

                              code = lookup(
                                    lookup(
                                          rules.value, 
                                          "icmp"
                                    ), 
                                    "code"
                              )
                        }
                  } 

                  ##############################################################################

            }
      }
}

##############################################################################