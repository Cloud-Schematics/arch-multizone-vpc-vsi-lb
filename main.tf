##############################################################################
# Terraform Providers
##############################################################################

terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.19.0"
    }
  }
}

##############################################################################

##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.ibm_region
  generation            = var.generation
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Resource Group where VPC will be created
##############################################################################

data ibm_resource_group resource_group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# VPC Module
# > Creates VPC
# > Creates ACL
# > Creates Subnets
# > (Optional) Creates Public Gateways
##############################################################################

module vpc {
  source                = "./multizone_vpc"

  # Account Variables
  unique_id             = var.unique_id
  ibm_region            = var.ibm_region
  resource_group_id     = data.ibm_resource_group.resource_group.id

  # VPC Variables
  acl_rules             = var.acl_rules
  enable_public_gateway = var.enable_public_gateway

}

##############################################################################


##############################################################################
# Compute Module
# > Creates SSH Key
# > Creates Block Storage Volumes
# > Creates Security Group
# > Creates Virtual Server Instances
##############################################################################

module compute {
  source               = "./vsi_workspace"

  # Account Variables
  unique_id            = var.unique_id
  resource_group_id    = data.ibm_resource_group.resource_group.id
  
  # VPC Variables
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.subnet_ids
  ssh_public_key       = var.ssh_public_key

  # VSI Variables
  enable_fip           = var.enable_fip
  image                = var.image
  machine_type         = var.machine_type
  vsi_per_subnet       = var.vsi_per_subnet
  security_group_rules = var.security_group_rules

  # Volume Variables
  subnet_zones         = module.vpc.subnet_zones
  volumes              = var.volumes

}

##############################################################################


##############################################################################
# Create Load Balancer For VSI
# > Creates Load Balancer
# > Creates Load Balancer Listener
# > Creates Load Balancer Member Pool
##############################################################################

module lb {
  source               = "./lb_module"

  # Account Variables
  unique_id            = var.unique_id
  resource_group_id    = data.ibm_resource_group.resource_group.id

  # VPC Variables
  subnet_list          = module.vpc.subnet_ids

  # VSI Variables
  vsi_list             = module.compute.vsi
  
  # Load Balancer Variables
  type                 = var.type

  # Listener Variables
  listener_port        = var.listener_port
  listener_protocol    = var.listener_protocol
  certificate_instance = var.certificate_instance
  connection_limit     = var.connection_limit

  # Pool Variables
  algorithm            = var.algorithm
  protocol             = var.protocol
  health_delay         = var.health_delay
  health_retries       = var.health_retries
  health_timeout       = var.health_timeout
  health_type          = var.health_type

  # Pool Member Variables
  pool_member_port     = var.pool_member_port
}

##############################################################################