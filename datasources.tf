## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# This data source provides details about a specific Namespace resource in OCI Object Storage service.
# Each OCI tenant is assigned one unique and uneditable Object Storage namespace. 
# The namespace is a system-generated string assigned during account creation. 
# See https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace
data "oci_objectstorage_namespace" "os_namespace" {
  compartment_id = var.compartment_ocid
}

# Gets a list of supported images based on the shape, operating_system and operating_system_version provided
data "oci_core_images" "compute_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
