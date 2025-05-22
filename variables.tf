## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Variables file

variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

variable "vcn_ocid" {}
variable "public_subnet_ocid" {}

# Create VCN
variable "use_existing_vcn" {
  description = "If true, select existing virtual cloud network for compute instance, else create new virtual cloud network."
  type = bool
  default = false
}

# Availability Domain
variable "ad_name" {
  description = "Select an Availability Domain for your compute instance. Availablity domain is one or more data centers located within a region."
}

# CPQ-Logging Analytics Resource Prefix
variable "cpq_logan_prefix" {
  description = "CPQ-Logging Analytics Resource Prefix"
}

# CPQ Host Name
variable "cpq_host" {
  description = "CPQ Host Name"
}

# CPQ API Version
variable "cpq_version" {
  description = "CPQ API Version"
}

# CPQ Username
variable "cpq_username" {
  description = "CPQ Username"
}

# CPQ Password
variable "cpq_pwd" {
  description = "CPQ Password"
  # Omit value from state. Note: Ephemeral variables are available in Terraform v1.10 and later. See: https://developer.hashicorp.com/terraform/language/values/variables#exclude-values-from-state
  #ephemeral = true
}

# OS Image
variable "image_operating_system" {
  default = "Oracle Linux"
}

# OS Version
variable "image_operating_system_version" {
  default = "9"
}

# Compute Shape (Always Free Eligible)
variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E2.1"
}

# Number of iterations to wait for CPQ credentials to be added to agent wallet
variable "num_iterations" {
  description = "Number of iterations to wait for CPQ credentials to be added to agent wallet"
  default     = "10"
}

# Wait duration in seconds
variable "wait_duration" {
  description = "Wait duration per iteration for CPQ credentials to be added to agent wallet"
  default     = "60"
}

# Dashboard JSON definitions
variable "dashboard_files" {
  description = "Dashboard JSON files"
  type = set(string)
  default = ["cpq-event-log-dashboard.json"]
}
