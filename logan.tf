## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Logging Analytics resources

locals {
  namespace = data.oci_objectstorage_namespace.os_namespace.namespace
  
  sources_path = "${path.module}/contents/sources"
  # Add timestamp to name to force TF to create zip during the pland and apply phases. See https://github.com/hashicorp/terraform-provider-archive/issues/39
  import_source_file = "${local.sources_path}/${var.cpq_logan_prefix}-${timestamp()}-sources.zip"

  entity_type = "Host (Linux)"
  entity_name = "${var.cpq_logan_prefix}-entity"  
}

# Logging Analytics Entity. Depends on Management Agent
resource "oci_log_analytics_log_analytics_entity" "logan_entity" {
  depends_on = [oci_management_agent_management_agent.logan_management_agent]

  compartment_id = var.compartment_ocid
  entity_type_name = local.entity_type
  name = local.entity_name
  namespace = local.namespace
  management_agent_id = oci_management_agent_management_agent.logan_management_agent.id

  # Set properties for CPQ host, API version, and Management Agent CPQ auth credentials identifier
  properties = tomap({ "HOST" = "${var.cpq_host}", "VERSION" = "${var.cpq_version}", "CREDS" = "${var.cpq_logan_prefix}-creds" })

}

# Wait for entity to be created (up to 3m)
resource "time_sleep" "wait_for_entity" {
  depends_on = [oci_log_analytics_log_analytics_entity.logan_entity]
  create_duration = "3m"
}

# Log Group
resource "oci_log_analytics_log_analytics_log_group" "logan_log_group" {
  compartment_id = var.compartment_ocid
  display_name = "${var.cpq_logan_prefix}-log-group"
  namespace = local.namespace
  description = "Log group for ${var.cpq_logan_prefix}"
  
  # Required to purge logs when destroying log group, else fails 
  # from_time=${formatdate("YYYY-MM-DD'T'hh:mm:ss", timestamp())}
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/logan.py purge_logs compartment_id=${self.compartment_id} log_group=${self.display_name} namespace=${self.namespace}"
  }

}

# Archive sources and parsers for upload
data "archive_file" "logan_source_zip" {
  type = "zip"
  source_dir  = "${local.sources_path}/"
  output_path = "${local.import_source_file}"
}

# Import sources and parsers. Depends on entity
resource "oci_log_analytics_log_analytics_import_custom_content" "cpq_sources" {
  depends_on = [data.archive_file.logan_source_zip, time_sleep.wait_for_entity]

  namespace = local.namespace
  is_overwrite = true
  import_custom_content_file = data.archive_file.logan_source_zip.output_path    
}


# Upsert or delete entity-source associations
resource "null_resource" "manage_assocs" {

  # When destroying, ensure that manage_assocs is taken down and completely destroyed before it begins work on delete_sources and delete_parsers. This destroy order is required by Logging Analytics.
  depends_on = [
    time_sleep.wait_for_entity, 
    oci_log_analytics_log_analytics_import_custom_content.cpq_sources, 
    oci_log_analytics_log_analytics_log_group.logan_log_group,
    null_resource.delete_sources,
    null_resource.delete_parsers
  ]

  triggers = {
    compartment_id = var.compartment_ocid
    entity_id = oci_log_analytics_log_analytics_entity.logan_entity.id
    loggroup_id = oci_log_analytics_log_analytics_log_group.logan_log_group.id
    # Read list of created source names from oci_log_analytics_log_analytics_import_custom_content output
    sources = join(",", flatten(oci_log_analytics_log_analytics_import_custom_content.cpq_sources.change_list[*].created_source_names)) # sources = outputs.created_source_names 
    namespace = local.namespace
  }

  # Create entity-source associations
  provisioner "local-exec" {
    command = "python3 ./scripts/logan.py upsert_entity_assocs compartment_id=${self.triggers.compartment_id} entity_id=${self.triggers.entity_id} namespace=${self.triggers.namespace} log_group_id=${self.triggers.loggroup_id} sources=${self.triggers.sources}"
  }

  # Remove entity-source associations when destroying entity
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/logan.py delete_entity_assocs compartment_id=${self.triggers.compartment_id} entity_id=${self.triggers.entity_id} namespace=${self.triggers.namespace} log_group_id=${self.triggers.loggroup_id}"
  }
}

# Delete sources
resource "null_resource" "delete_sources" {

  # Ensure that delete_sources is taken down and completely destroyed before it begins work on delete_parsers. This destroy order is required by Logging Analytics.
  depends_on = [null_resource.delete_parsers]

  triggers = {
    compartment_id = var.compartment_ocid
    namespace = local.namespace
    # Read list of created source names from oci_log_analytics_log_analytics_import_custom_content output
    source_names = join(",", flatten(oci_log_analytics_log_analytics_import_custom_content.cpq_sources.change_list[*].created_source_names))
  }

  # Remove sources when destroying stack
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/logan.py delete_sources compartment_id=${self.triggers.compartment_id} namespace=${self.triggers.namespace} names=${self.triggers.source_names}"
  }
}

# Delete parsers
resource "null_resource" "delete_parsers" {

  triggers = {
    namespace = local.namespace
    # Read list of created parser names from oci_log_analytics_log_analytics_import_custom_content output
    parser_names = join(",", flatten(oci_log_analytics_log_analytics_import_custom_content.cpq_sources.change_list[*].created_parser_names))
  }

  # Remove parsers when destroying stack
  provisioner "local-exec" {
    when = destroy
    command = "python3 ./scripts/logan.py delete_parsers namespace=${self.triggers.namespace} names=${self.triggers.parser_names}"
  }
}