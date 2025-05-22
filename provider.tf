## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# See https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm#Enabling_Instance_Principal_Authorization_for_Terraform
provider "oci" {
  auth = "InstancePrincipal"
  region = var.region
  tenancy_ocid = var.tenancy_ocid
}