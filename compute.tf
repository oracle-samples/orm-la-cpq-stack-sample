## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Compute Instance

data "template_file" "user_data" {
  template = file("oci-cloud-init.sh")

  vars = {
    cpq_username = var.cpq_username
    cpq_pwd = var.cpq_pwd
    cpq_cred_name = "${var.cpq_logan_prefix}-creds"
    num_iterations = var.num_iterations
    wait_duration = var.wait_duration
  }
}

resource "oci_core_instance" "mgmtagent_instance" {
  #availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad -1]["name"]
  availability_domain = var.ad_name
  compartment_id = var.compartment_ocid
  display_name = "${var.cpq_logan_prefix}-compute"
  shape = var.instance_shape

  # Enable plugin "Management Agent" for REST API log collection
  agent_config {
    plugins_config {
      desired_state = "ENABLED"
      name = "Management Agent"
    }
  }

  # If use_existing_vcn selected, use selected public subnet; else use new public subnet
  create_vnic_details {
    assign_public_ip = true    
    subnet_id   = var.use_existing_vcn ? var.public_subnet_ocid : oci_core_subnet.public_oci_core_subnet[0].id
    #subnet_id = var.public_subnet_ocid
    #subnet_id = oci_core_subnet.public_oci_core_subnet.id
    display_name = "${var.cpq_logan_prefix}-vnic"
  }

  source_details {
    source_type = "image"
    source_id = lookup(data.oci_core_images.compute_images.images[0], "id")
  }

  # Provide information to Cloud-Init to be used for system initialization tasks.
  metadata = {
    # Provide one or more public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance.
    ssh_authorized_keys = var.ssh_public_key
    # Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration.
    user_data = base64encode(data.template_file.user_data.rendered)
  }

  # The compute instance cloud-init script has a "hidden" dependency on
  # the Management Agent Logging Analytics plugin that Terraform cannot
  # automatically infer, so it must be declared explicitly:
  depends_on = [
    data.oci_management_agent_management_agent_plugins.logan_management_agent_plugins
  ]  

}
