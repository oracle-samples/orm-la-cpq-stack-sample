## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Management Agent

data "oci_management_agent_management_agents" "find_agent" {
    compartment_id = var.compartment_ocid
    host_id = oci_core_instance.mgmtagent_instance.id
    wait_for_host_id = 10
}

data "oci_management_agent_management_agent_plugins" "logan_management_agent_plugins" {
  compartment_id = var.compartment_ocid
  display_name   = "Logging Analytics"
}

resource "oci_management_agent_management_agent" "logan_management_agent" {
  display_name = "${var.cpq_logan_prefix}-mgmtagent"
  managed_agent_id  = data.oci_management_agent_management_agents.find_agent.management_agents[0].id
  deploy_plugins_id = [data.oci_management_agent_management_agent_plugins.logan_management_agent_plugins.management_agent_plugins.0.id]
}