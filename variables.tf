##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-mz-vpc"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group {
    description = "Name of resource group to create VPC"
    type        = string
    default     = "asset-development"
}

variable generation {
  description = "generation for VPC. Can be 1 or 2"
  type        = number
  default     = 2
}

variable enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  type        = bool
  default     = true
}

variable acl_rules {
  description = "Access control list rule set"
  default     = [
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


variable cidr_blocks {
    description = "CIDR blocks for subnets to be created. If no CIDR blocks are provided, it will create subnets with 256 total ipv4 addresses"
    type        = list(string)
    default     = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]  
}

##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable ssh_public_key {
  description = "ssh public key to use for vsi"
  type        = string
}

variable image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "bx2-8x32"
}

variable vsi_per_subnet {
    description = "Number of VSI instances for each subnet"
    type        = number
    default     = 1
}

variable enable_fip {
  description = "Enable floating IP. Can be true or false"
  type        = bool 
  default     = true
}

variable security_group_rules {
  description = "List of security group rules to be added to default security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    },
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

variable volumes {
  description = "A list of maps describng the volumes for each of the VSI"
  /*
  type         = list(object({
      name           = string   
      profile        = string
      iops           = number       # Optional
      capacity       = number       # Optional
      encryption_key = string       # Optional
      tags           = list(string) # Optional
  }))
  */
  default     = [
    {
      name     = "one"
      profile  = "10iops-tier"
      capacity = 25
    },
    {
      name    = "two"
      profile = "10iops-tier"
    },
    {
      name    = "three"
      profile = "10iops-tier"
    }
  ]
}

##############################################################################


##############################################################################
# LB Variables
##############################################################################

variable type {
    description = "Load Balancer type, can be public or private"
    type        = string
    default     = "public"
}


##############################################################################


##############################################################################
# Listener Variables
##############################################################################

variable listener_port {
    description = "Listener port"
    type       = number
    default     = 80
}


variable listener_protocol {
    description = "The listener protocol. Supported values are http, tcp, and https"
    type        = string
    default     = "http"
}

variable certificate_instance {
    description = "Optional, the CRN of a certificate instance to use with the load balancer. To not use a certificate instance, leave string empty"
    type        = string
    default     = ""
}

variable connection_limit {
    description = "Optional, connection limit for the listener. Valid range 1 to 15000. To not enforce connection limit, leave as 0."
    type        = number
    default     = 0
}

##############################################################################


##############################################################################
# Pool Variables
##############################################################################

variable algorithm {
    description = "The load balancing algorithm. Supported values are round_robin, or least_connections. This module can be modified to use weighted_round_robin by adding `weight` to the load balancer pool members."
    type        = string
    default     = "round_robin"
}

variable protocol {
    description = "The pool protocol. Supported values are http, and tcp."
    type        = string    
    default     = "http"
}

variable health_delay {
    description = "The health check interval in seconds. Interval must be greater than timeout value."
    type        = number
    default     = 11
}

variable health_retries {
    description = "The health check max retries."
    type       = number
    default     = 10
}

variable health_timeout {
    description = "The health check timeout in seconds."
    type       = number
    default     = 10    
}

variable health_type {
    description = "The pool protocol. Supported values are http, and tcp."
    type        = string
    default     = "http"
}

##############################################################################


##############################################################################
# Pool Member Variables
##############################################################################

variable pool_member_port {
    description = "The port number of the application running in the server member."
    default     = 80
}

##############################################################################