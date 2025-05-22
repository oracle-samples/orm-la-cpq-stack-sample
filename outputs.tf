## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

output "instance_public_ip" {
  description = "Public IP address for compute instance running Management Agent."
  value = oci_core_instance.mgmtagent_instance.public_ip
}

# Output list of created sources
# See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_import_custom_content#created_source_names-1
output "created_source_names" {
  description = "List of created source names."
  value = oci_log_analytics_log_analytics_import_custom_content.cpq_sources.change_list[*].created_source_names
}

# Output list of created parsers
# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_import_custom_content#created_parser_names-1
output "created_parser_names" {
  description = "List of created parser names."
  value = oci_log_analytics_log_analytics_import_custom_content.cpq_sources.change_list[*].created_parser_names
}

# Output list of dashboard names
output "dashboard_names" {
  description = "List of dashboard names."
  value = join(",", local.dashboards)
}

# Output list of saved search names
output "saved_search_names" {
  description = "List of saved search names."
  value = join(",", local.saved_searches)
}
