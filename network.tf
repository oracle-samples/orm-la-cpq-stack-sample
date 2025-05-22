# Copyright (c) 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Virtual cloud network definitions

locals {
    vcn_cidr_block = "10.0.0.0/16" # VCN CIDR block
    vcn_public_subnet_cidr_block = "10.0.0.0/24" # Public subnet CIDR block
    vcn_private_subnet_cidr_block = "10.0.1.0/24" # Private subnet CIDR block
}

# Conditionally create VCN if use_existing_vcn is not selected
resource "oci_core_vcn" "generated_oci_core_vcn" {
	count   = var.use_existing_vcn ? 0 : 1
    cidr_block = local.vcn_cidr_block
	compartment_id = var.compartment_ocid
	display_name = "vcn-oci-server"
}

resource "oci_core_subnet" "public_oci_core_subnet" {
    count   = var.use_existing_vcn ? 0 : 1
    #Required
	vcn_id = oci_core_vcn.generated_oci_core_vcn[0].id	
	cidr_block = local.vcn_public_subnet_cidr_block
    compartment_id = var.compartment_ocid

    display_name = "public-subnet-vcn-oci-server"
    # Route table with internet gateway rule   
	route_table_id = oci_core_route_table.generated_oci_core_default_route_table[0].id 
	# Security list with ingress rules for web server and Jaeger ports
    security_list_ids = [oci_core_security_list.generated_oci_core_default_security_list[0].id]
}

resource "oci_core_subnet" "private_oci_core_subnet" {
    count   = var.use_existing_vcn ? 0 : 1
    # Required
	vcn_id = oci_core_vcn.generated_oci_core_vcn[0].id
	cidr_block = local.vcn_private_subnet_cidr_block
	compartment_id = var.compartment_ocid

	display_name = "private-subnet-vcn-oci-server"
    # Route table with internet gateway rule
	route_table_id = oci_core_route_table.generated_oci_core_default_route_table[0].id 
	# Security list with ingress rules for web server and Jaeger ports
    security_list_ids = [oci_core_security_list.generated_oci_core_default_security_list[0].id]
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
	count   = var.use_existing_vcn ? 0 : 1
    # Required
	compartment_id = var.compartment_ocid
	vcn_id = oci_core_vcn.generated_oci_core_vcn[0].id

	display_name = "ig-vcn-oci-server"
	enabled = "true"
}

resource "oci_core_route_table" "generated_oci_core_default_route_table" {
    count   = var.use_existing_vcn ? 0 : 1
    # Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.generated_oci_core_vcn[0].id

    display_name = "routetable-vcn-oci-server"

    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.generated_oci_core_internet_gateway[0].id
    }
}

resource "oci_core_security_list" "generated_oci_core_default_security_list" {
    count   = var.use_existing_vcn ? 0 : 1
    # Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.generated_oci_core_vcn[0].id

    display_name = "seclist-vcn-oci-server"

    egress_security_rules {
        description = "All traffic for all ports"
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol  = "all"
        stateless = "false"
    }

    ingress_security_rules {
        description = "Allow SSH remote login"
        protocol    = "6"
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        stateless   = "false"
        tcp_options {
            max = "22"
            min = "22"
        }
    }

    ingress_security_rules {
        description = "ICMP traffic for 3, 4"
        icmp_options {
            code = "4"
            type = "3"
        }
        protocol    = "1"
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        stateless   = "false"
    }

    ingress_security_rules {
        description = "ICMP traffic for 3"
        icmp_options {
            code = "-1"
            type = "3"
        }
        protocol    = "1"
        source      = "10.0.0.0/16"
        source_type = "CIDR_BLOCK"
        stateless   = "false"
    }
}
