#!/bin/bash
#
## Copyright (c) 2025, Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl
#
# cloud-init script for Management Agent initialization for Logging Analytics (logan) plugin on compute instance
#
# Description: Run by cloud-init at instance provisioning.

PGM=$(basename $0)

TMP_DIR=$(pwd)/cloud_init_tmp

# Path values
BASE_DIR="/var/lib/oracle-cloud-agent/plugins/oci-managementagent"
CREDS_SCRIPT="$BASE_DIR/polaris/agent_inst/bin/credential_mgmt.sh"
CREDS_JSON_FILE="$TMP_DIR/logan_credentials.json"

# Oracle management agent user
AGENT_USER="oracle-cloud-agent"

#######################################
# Print header
# Globals:
#   PGM
#######################################
echo_header() {
	echo "$(date "+%Y-%m-%d %H:%M:%S,%3N") - +++ $PGM: $@"
}

#######################################
# Add Management Agent Credentials
#######################################
upsert_credentials() {
		
	echo_header "Begin adding '${cpq_cred_name}' credentials to management agent wallet."

	# Create temp dir
	sudo mkdir $TMP_DIR

	# Create credentials json file
	cat <<EOF > $CREDS_JSON_FILE
{
  "source":"lacollector.la_rest_api",
  "name":"${cpq_cred_name}",
  "type":"HTTPSBasicAuthCreds",
  "description":"These are CPQ BasicAuth credentials.",
  "properties":
  [
    { "name":"HTTPSUserName", "value":"CLEAR[${cpq_username}]" },
    { "name":"HTTPSPassword", "value":"CLEAR[${cpq_pwd}]" }
  ]
}
EOF

	t=0
	# Check if credentials script is available and management agent installed
	until (( t++ >= "${num_iterations}" )); do
  		echo_header "Waiting for agent to become available..."
		sleep "${wait_duration}"

		# Add new credentials to management agent wallet and evaluate response
    	cmd_response=$(sudo -u oracle-cloud-agent bash -c "cat $CREDS_JSON_FILE | bash $CREDS_SCRIPT -s logan -o upsertCredentials" | grep "logan" 2>&1)
    	cmd_response_exit_code=$?

    	if [[ $cmd_response_exit_code != 0 ]]; then
      		echo_header "Agent Logan service not available. Response: $cmd_response"
		else
			echo_header "Successfully added '${cpq_cred_name}' credentials to management agent wallet."
			break
    	fi

	done

	echo_header "End adding '${cpq_cred_name}' credentials to management agent wallet."

}

#######################################
# Cleanup
#######################################
cleanup_before_exit(){
	# Delete temporarily create files
  	rm -rf $TMP_DIR
  	echo_header "Deleted temporary files"
}


#######################################
# Main
#######################################
main() {

	cp /etc/motd /etc/motd.bkp
	cat << EOF > /etc/motd
 
I have been modified by cloud-init at $(date)
 
EOF
	echo_header "Starting cloud-init!"
	upsert_credentials
	trap cleanup_before_exit EXIT 

}

main "$@"