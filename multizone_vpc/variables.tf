##############################################################################
# Account Variables
##############################################################################

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-multizone"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
    default     = "us-south"
}

variable resource_group_id {
    description = "ID of resource group to create VPC"
    type        = string
}

##############################################################################


##############################################################################
# Network variables
##############################################################################

variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  #type        = bool
  default     = false
}

variable enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  #type        = bool
  default     = true
}

variable acl_rules {
  description = "Access control list rule set"
  default = [
    {
      name        = "egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
  
}

variable default_sg_allow_inbound_traffic {
  description = "In Gen2 the default security group denies all inbound traffic into the VPC. If you would like to add a rule to allow all traffic, change this value to true"
  type        = bool
  default     = true
}

variable cidr_blocks {
    description = "CIDR blocks for subnets to be created. If no CIDR blocks are provided, it will create subnets with 256 total ipv4 addresses"
    type        = list(string)
    default     = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]  
}

##############################################################################