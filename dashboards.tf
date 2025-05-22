## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Management Dashboard resources

locals {
    dashboards_path = "${path.module}/contents/dashboards"
    # List all dashboard json files in path
    json_files = fileset(local.dashboards_path, "*.json")
    json_data  = [for f in local.json_files : jsondecode(file("${local.dashboards_path}/${f}"))]
    # Read list of dashboard names from included dashboard json files
    dashboards = flatten(local.json_data[*].dashboards[*].displayName)
    # Read list of saved search names from included dashboard json files
    saved_searches = flatten(local.json_data[*].dashboards[*].savedSearches[*].displayName)
}

# Imports an array of dashboards and their saved searches
# See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/management_dashboard_management_dashboards_import
resource "oci_management_dashboard_management_dashboards_import" "cpq_dashboards" { 
    depends_on = [oci_log_analytics_log_analytics_entity.logan_entity]

    for_each = var.dashboard_files 
        import_details = templatefile("${local.dashboards_path}/${each.value}", {"compartment_ocid" : "${var.compartment_ocid}", "cpq_logan_prefix": "${var.cpq_logan_prefix}"})
}

# Delete dashboards on destroy
resource "null_resource" "delete_dashboards" {

  depends_on = [oci_management_dashboard_management_dashboards_import.cpq_dashboards]

  triggers = {
    id = timestamp() # dynamic trigger that ensures resource re-executes every apply/destroy
    compartment_id = var.compartment_ocid
    dashboards = join(",", local.dashboards)
  }

  # Remove dashboards by name (wrap parameter in quotes)
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/dashboards.py delete_dashboards compartment_id=${self.triggers.compartment_id} dashboards=\"${self.triggers.dashboards}\""
  }
}

# Delete saved searches on destroy
resource "null_resource" "delete_savedsearches" {

  depends_on = [oci_management_dashboard_management_dashboards_import.cpq_dashboards]

  triggers = {
    id = timestamp() # dynamic trigger that ensures resource re-executes every apply/destroy
    compartment_id = var.compartment_ocid
    saved_searches = join(",", local.saved_searches)
  }

  # Remove saved searches by name (wrap parameter in quotes)
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/dashboards.py delete_savedsearches compartment_id=${self.triggers.compartment_id} saved_searches=\"${self.triggers.saved_searches}\""
  }
}
