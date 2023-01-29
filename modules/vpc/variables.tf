
project = "lecp"
owner   = "terraform"

domain_name      = "ice.mod.gov.uk"
r53              = "tooling-dev.ice.mod.gov.uk"
sla              = "7-7"
remote_access_ip = "37.60.86.13/32" #37.60.64.0/19? - the old IP was 37.60.76.19
region           = "eu-west-2"
bkp_retain       = "ice_7" # 7 day retention of AMI backups

# VPC
enable_dns_hostnames = true
enable_dns_support   = true

# Subnets: public
pb0_az   = ["eu-west-2a", "eu-west-2b"]
pb0_name = "ext1"

# Subnets: private AD
pv0_az   = ["eu-west-2a", "eu-west-2b"]
pv0_name = "int1_ad"

# Subnets: private Endpoints
pv1_az   = ["eu-west-2a", "eu-west-2b"]
pv1_name = "int2_endpoints"

inbound_dns_ips = ["10.3.8.54", "10.3.9.54"]

# Subnets: private Tooling
pv2_az   = ["eu-west-2a", "eu-west-2b"]
pv2_name = "int3_tooling"

#################################################################
# workspace specific variables are "" and must be set in tfvars #
# ,however, setting in tfvars will always override!             #
#################################################################

# global
variable "owner" {
}

variable "region" {
}

variable "remote_access_ip" {
}

variable "sla" {
}

variable "bkp_retain" {
}

# *.tf
variable "project" {
}

# vpc_infrastructure.tf

variable "enable_dns_hostnames" {
}

variable "enable_dns_support" {
}

variable "domain_name" {
}

variable "r53" {
}

variable "pb0_az" {
  type = list(string)
}

variable "pb0_name" {
}


variable "pv0_az" {
  type = list(string)
}

variable "pv0_name" {
}

variable "pv1_az" {
  type = list(string)
}

variable "pv1_name" {
}

variable "pv2_az" {
  type = list(string)
}

variable "pv2_name" {
}

variable "pv3_az" {
  type = list(string)
}

variable "pv3_name" {
}

# dhcp_options.tf
variable "ntp" {
}

# directory.tf
variable "ds_pw" {
}

variable "ds_type" {
}

variable "ds_edition" {
}

variable "ds_alias" {
}

# vm_rsat.tf
variable "rsat_ami" {
}

variable "rsat_type" {
}

variable "rsat_name" {
}

# vm_ca.tf
variable "ca_ami" {
}

variable "ca_type" {
}

variable "ca_name" {
}

# VPN

variable "vpn_ami" {
}

variable "vpn_type" {
}

variable "vpn_rootvol" {
}

variable "vpn_asg_max_size" {
}

variable "vpn_asg_min_size" {
}

variable "vpn_asg_desired_capacity" {
}
variable "vpnadjoin" {
  type = bool
}

variable "AD_JOIN_USER" {
}

variable "AD_JOIN_PASS" {
}

# eks

variable "cluster_version" {
}
variable "worker_version" {
}
variable "map_roles_count" {
}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_users_count" {
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "eks-worker-template-az2-nginx_asg_max_size" {
}

variable "whitelisted_principals" {
  type = list(string)
}

variable "map_accounts_count" {
}

variable "map_accounts" {
  type = list(string)
}

variable "trend_endpoint_name" {
}

variable "splunk_endpoint_name" {
}

variable "inbound_dns_ips" {
  type = list(string)
}

# ice_tooling_certificate.off
#variable "BUNDLE" {}
#variable "KEY" {}
#variable "CERT" {}

variable "DB_USER" {
}

variable "DB_PASSWORD" {
}

# Transit Gateway
variable "AWS_ACCESS_KEY_ID_TGW" {
}

variable "AWS_SECRET_ACCESS_KEY_TGW" {
}

variable "AWS_SESSION_TOKEN_TGW" {
}

variable "tgw_environment" {
  description = "The environment of the TGW (dev/prod)"
  type        = string
  default     = "prod"
}


variable "asg_service_linked_role_suffix" {
}

variable "AWS_ACCESS_KEY_ID_TRAZO" {

}

variable "AWS_SECRET_ACCESS_KEY_TRAZO" {

}

variable "AWS_SESSION_TOKEN_TRAZO" {

}

# for creating endpoints on loadbalancers created by EKS

variable "nw_loadbalancer_arn" {
  type = string
}

variable "nw_loadbalancer_name" {
  type = string
}

#Patching
variable "env" {
  description = "The environment we're in"
}

variable "scan_patching_schedule" {
  description = "The schedule for patch scanning"
}

variable "apply_patching_schedule" {
  description = "The schedule for patch application"
}

variable "environment_toggle" {
  description = "A flag to enable or disable patch apply module calls in differing environments"
  type        = string
  default     = "enabled"
}

variable "approve_after_days" {
  description = "How many days after the patch is approved, does it get applied"
  type        = number
  default     = 7
}