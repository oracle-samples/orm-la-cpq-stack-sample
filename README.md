# ORM CPQ Logging Analytics Integration Stack

Oracle Cloud Infrastructure [Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) stack configuration for [OCI Logging Analytics](https://www.oracle.com/manageability/logging-analytics/) and [Oracle Configure, Price, Quote (CPQ)](https://www.oracle.com/cx/sales/cpq/) event log analysis setup. 

The integration configures [Logging Analytics](https://www.oracle.com/manageability/logging-analytics/) components and dashboards for [Oracle CPQ](https://www.oracle.com/cx/sales/cpq/) events analysis and enables continuous [REST API log collection](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/set-rest-api-log-collection.html). Log collection is run by the [Management Agent](https://docs.oracle.com/en-us/iaas/management-agents/doc/management-agents-administration-tasks.html), which is a service enabled on an OCI Compute Instance.

## Features
Using this integration CPQ customers can quickly gain insight into the performance of product configurations, quote management, and deal negotiation tasks. Ensuring their CPQ applications are fast and reliable is essential to Oracle's customers for maintaining competitiveness in today's dynamic B2B environment and the CPQ - Logging Analytics integration makes it easy to gain insights about CPQ performance.

Keeping a handle on the performance of your CPQ applications can be difficult due the large volume of data that is generated each day. Couple that volume with the complexity of each interaction in your business that is reflected in the logs and the challenge of gaining insight becomes very expensive and labor intensive. The CPQ - OCI Logging Analytics integration will help you wrangle your log data. Here's how:

### Automate
OCI services enable CPQ customers to automate ingest, enrichment, and analysis of event logs.

#### Automate log collection
Using OCI native services, CPQ admins can automate the continuous collection of CPQ event logs and easily visualize, create alerts, and run advanced analytics on Oracle CPQ performance logs with Logging Analytics.

#### Automate alerts
OCI Logging Analytics supports a rich selection of alert mechanisms including via email, SMS, Slack, or PagerDuty,

### Monitor
Ensure your business goals are consistently met by leveraging Logging Analytics dashboards to surface important information.

#### Display overall application health
With pre-built dashboards, business leaders and their teams can easily review top-level metrics and determine the overall health of their CPQ applications.  The CPQ performance dashboard contains both summary and trend information on number of requests, request response times, and number of unique users. Each metric is broken out by node, event type, and component.

#### Monitor trends in your CPQ application
Take advantage of Logging Analytics pre-built machine learning algorithms to view behavior over time of key CPQ metrics including: 

* Number of concurrent users
* Average response time
* Frequency of Model actions

#### Monitor performance threats
CPQ admins can now leverage the parsing and data enrichment including [Geolocation](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/create-log-source.html) and [Threat Scores](https://docs.oracle.com/en-us/iaas/Content/threat-intel/using/overview.htm) for public IPs that come pre-configured in the integration to set up alerts that keep the team informed of any performance threats or degradations so that any incident is handled quickly.

### Troubleshoot
Logging Analytics enables analysis of long-term performance trends, user activity analysis, and object changes through its Log Explorer interactive analytics interface. CPQ admins can leverage these interactive tools to identify trends and perform root cause analysis.

### Act
When emergencies occur, ensure that your team is immediately aware of the issue and are given both data and context to be able to solve it as quickly as possible. OCI Logging Analytics allows you to specify alerts that can be configured based on event criteria thresholds you configure and broadcast to your team. 

## Components

### Resource Manager

[Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) is an Oracle Cloud Infrastructure service that allows you to automate the process of provisioning your Oracle Cloud Infrastructure resources. Using [Terraform](https://www.terraform.io/), Resource Manager helps you install, configure, and manage resources through the "infrastructure-as-code" model.

A Terraform configuration codifies your infrastructure in declarative configuration files. Resource Manager allows you to share and manage infrastructure configurations and state files across multiple teams and platforms. This infrastructure management can't be done with local Terraform installations and Oracle Terraform modules alone

### Logging Analytics
Oracle [Logging Analytics](https://www.oracle.com/manageability/logging-analytics/) is a cloud solution in Oracle Cloud Infrastructure that lets you index, enrich, aggregate, explore, search, analyze, correlate, visualize, and monitor all log data from your applications and system infrastructure.

### Configure Price Quote (CPQ)
[Oracle CPQ](https://www.oracle.com/cx/sales/cpq/) is a cloud-based application that helps sellers configure the right mix of products or services and create accurate, professional quotes to quickly meet their customers’ pricing needs.

Oracle CPQ logs all user actions including logins, logouts, commerce and configuration actions. Each of these events capture elapsed server and browser times to complete which make the log essential in troubleshooting performance issues. CPQ admins can view the performance log in the UI Designer, but potentially more useful, you can also view log entries and download logs using the CPQ REST APIs. This integration uses these APIs to script downloading logs to ingest them into the OCI Observability and Management Logging Analytics service.

## Getting Started

When you [sign up](https://www.oracle.com/cloud/free/) for an Oracle Cloud Infrastructure account, you’re assigned a secure and isolated partition within the cloud infrastructure called a *tenancy*. The tenancy is a logical concept and you can think of it as a root container where you create, organize, and administer your cloud resources. 

The second logical concept used for organizing and controlling access to cloud resources is compartments. A *compartment* is a collection of related cloud resources.Every time you create a cloud resource, you must specify the compartment that you want the resource to belong to.

Ensure you have access to a compartment in your tenancy as well as the following services:
* [Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm)
* [Logging Analytics](https://www.oracle.com/manageability/logging-analytics/)
* [Configure Price Quote](https://www.oracle.com/cx/sales/cpq/)

### Enable Logging Analytics
Follow the instructions in the [Oracle Cloud Infrastructure Logging Analytics Quick Start Guide](https://docs.oracle.com/en/cloud/paas/logging-analytics/logqs/#before_you_begin) to enable the Logging Analytics service in your compartment.

### Gather Your Oracle CPQ Account Information
The integration leverages [Oracle CPQ REST APIs](https://docs.oracle.com/en/cloud/saas/configure-price-quote/cxcpq/) to retrieve event log data. In order to make REST HTTP requests, you need to gather a few bits of information, including:
* Oracle CPQ host name, ie. _example.oracle.com_
* User name and password. Oracle CPQ service user with permissions to access REST API resources.

You can find the REST Server URL, user name, and password in the welcome email sent to your Oracle CPQ service administrator.

### Create Stack
Follow the instructions to [create a stack from a zip file](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/create-stack-local.htm)

#### Console Instructions
1. Open the navigation menu and click Developer Services. Under Resource Manager, click Stacks.
2. Choose a compartment that you have permission to work in.
3. Click Create stack.
4. In the Create stack page, under Choose the origin of the Terraform configuration, select My configuration.
5. Under Stack configuration, select .Zip file.
6. Drag and drop a .zip file onto the dialog's control or click Browse and navigate to the location of the .zip file you want. The dialog box is populated with information contained in the Terraform configuration.
7. Fill in the remaining fields.
8. Review and click Create to create your stack.

#### CLI Instructions

Use the ```oci resource-manager stack create``` [command](https://docs.oracle.com/iaas/tools/oci-cli/latest/oci_cli_docs/cmdref/resource-manager/stack/create.html) and required parameters to create a stack from a local zip file.

Example request:

```
oci resource-manager stack create --compartment-id ${compartment.ocid} --config-source ${zipfile} --variables file://variables.json --display-name "CPQ Logging Analytics Integration Stack" --description "Automate Logging Analytics and CPQ reporting setup in your OCI compartment" --working-directory ""
```

Note, the ```variables``` parameter allows you to pass through Terraform variables associated with this resource. Example: {"vcn_cidr_block": "10.0.0.0/16"} This is a complex type whose value must be valid JSON. The value can be provided as a string on the command line or passed in as a file using the file://path/to/file syntax.

### Apply Stack

When you run an apply job for a stack, Terraform provisions the resources and executes the actions defined in your Terraform configuration, applying the execution plan to the associated stack to create your Oracle Cloud Infrastructure resources. We recommend running a plan job (generating an execution plan) before running an apply job.

#### Console Instructions

1. Open the navigation menu and click Developer Services. Under Resource Manager, click Stacks.
2. Choose a compartment that you have permission to work in.
3. Click the name of the stack that you want. The Stack details page opens.
4. Click Apply. 

#### CLI Instructions

Use the ```oci resource-manager job create-apply-job``` [command](https://docs.oracle.com/iaas/tools/oci-cli/latest/oci_cli_docs/cmdref/resource-manager/job/create-apply-job.html) and required parameters to run an apply job.

Example request using automatically approve option:

```
oci resource-manager job create-apply-job --execution-plan-strategy AUTO_APPROVED  --stack-id ${stack.ocid}
```
### Run scripts locally

This project includes a number of Python scripts that can be run and tested locally.

#### Set up a virtual environment

Creating a Python virtual environment allows you to manage dependencies separately for your different projects, preventing conflicts and maintaining cleaner setups. To create and activate a virtual environment:

```python
virtualenv <environment name>
source <environment name>/bin/activate
```

For example:
```python
virtualenv blogs_analysis_env
source blogs_analysis/bin/activate
pip install -r requirements.txt
```

### Continuous REST API Log Collection

The integration uses the [continuous REST API log collection](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/set-rest-api-log-collection.html) feature of Logging Analytics, which is recommended for automating log collection from services like Oracle CPQ that emit logs through an API.

Continuous log collection is controlled by a Management Agent running as a plugin on a compute instance. To learn more about how Management Agents work, see the post [Demystifying Logging and Monitoring Agent Types in OCI Observability and Management](https://www.ateam-oracle.com/post/demystifying-logging-and-monitoring-agent-types-in-oci-observability-and-management).

The compute instance which the stack will create contains a [cloud-init](https://cloudinit.readthedocs.io/en/latest/) script. Cloud-init is the industry standard multi-distribution method for cross-platform cloud instance initialisation and provides the necessary glue between launching a cloud instance and configuring the Management Agent plugin so that it works as expected.

The cloud-init script will initialize the Management Agent for use of the Logging Analytics (logan) plugin on the newly created compute instance by adding CPQ BasicAuth credentials to the Management Agent wallet.

## Resources
The following resources are created in the specified compartment.

### Network
Network resources include a Virtual Cloud Network (VCN), public and private subnets, and the corresponding route table, internet gateway and security list. Security list ingress rules allow traffic on port 22 for SSH access to the compute instance.
 
| Name | Type | Description |
| ----------- | ----------- | ----------- |
| vcn-oci-server | [oci_core_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | Virtual Cloud Network (VCN) in specified compartment. See [VCNs and Subnets](https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingVCNs.htm) |
| public-subnet-vcn-oci-server | [oci_core_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | Public subnet resource in the specified VCN |
| private-subnet-vcn-oci-server | [oci_core_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | Private subnet resource in the specified VCN |
| ig-vcn-oci-server | [oci_core_internet_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | Internet gateway resource in the specified VCN |
| routetable-vcn-oci-server | [oci_core_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | Route table resource in the specified VCN |
| seclist-vcn-oci-server | [oci_core_security_list](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | Security list resource in the specified VCN see [Security Lists](https://docs.cloud.oracle.com/iaas/Content/Network/Concepts/securitylists.htm) |


### Compute
Compute resources include the compute instance with the "Management Agent" plugin enabled for REST API log collection.

| Name | Type | Description |
| ----------- | ----------- | ----------- |
| mgmtagent_instance | [oci_core_instance](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | Compute instance resource in the specified compartment. |

### Management Agent
Management Agent resources include the Logging Analytics (logan) plugin which uses the credentials in its wallet to authenticate with the CPQ REST API when collecting logs.

| Name | Type | Description |
| ----------- | ----------- | ----------- |
| logan_management_agent | [oci_management_agent_management_agent](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/management_agent_management_agent) | Management Agent resource in the specified compartment. |


### Logging Analytics
Logging Analytics resources include the entity, log groups, sources, and parsers.

| Name | Type | Description |
| ----------- | ----------- | ----------- |
| logan_entity | [oci_log_analytics_log_analytics_entity](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_entity) | Entity resource in the specified compartment which links the Management Agent to log sources. |
| logan_log_group | [oci_log_analytics_log_analytics_log_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_log_group) | Logical location where logs are stored in the specified compartment. |
| cpq_sources | [oci_log_analytics_log_analytics_import_custom_content](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_import_custom_content) | Imports the specified custom content including log sources and parsers from the input in zip format. |

### Management Dashboards
[Management Dashboards](https://docs.oracle.com/en-us/iaas/management-dashboard/doc/management-dashboard.html), part of OCI Observability & Management, allow you to build performance monitoring, diagnosis and data analysis solutions and consist of query-based widgets, which are a single data visualization for one type of resource.
 
| Name | Type | Description |
| ----------- | ----------- | ----------- |
| cpq_dashboards | [oci_management_dashboard_management_dashboards_import](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/management_dashboard_management_dashboards_import) | Imports an array of dashboards and their saved searches in the specified compartment. |


## Variables
There are a number of variables that are employed by the stack.

| Name | Description | Default Value |
| ----------- | ----------- | ----------- |
| *tenancy_ocid* | Tenancy OCID | Automatically populated by OCI. See [Terraform Configurations for Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/terraformconfigresourcemanager.htm) |
| *region* | Region name | Automatically populated by OCI. See [Terraform Configurations for Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/terraformconfigresourcemanager.htm) |
| *compartment_ocid* | Compartment OCID | Automatically populated by OCI. See [Terraform Configurations for Resource Manager](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/terraformconfigresourcemanager.htm) |
| *ssh_public_key* | SSH public Key used to login to compute instance |  |
| *vcn_ocid* | Virtual cloud network OCID |  |
| *public_subnet_ocid* | Public subnet OCID |  |
| *cpq_logan_prefix* | CPQ-Logging Analytics resource prefix |  |
| *cpq_host* | CPQ host name |  |
| *cpq_version* | CPQ API Version |  |
| *cpq_username* | CPQ Username |  |
| *cpq_pwd* | CPQ Password |  |
| *ad* | Availability domain to deploy resources | 1 |
| *image_operating_system* | Compute image operating system | Oracle Linux |
| *image_operating_system_version* | Compute image operating system version | 9 |
| *instance_shape* | Compute image shape | VM.Standard.E2.1 |
| *num_iterations* | Number of iterations to wait for CPQ credentials to be added to agent wallet | 10 |
| *wait_duration* | Wait duration per iteration for CPQ credentials to be added to agent wallet | 50 |
| *dashboard_files* | Dashboard JSON files list |  |


## Cloud-Init Script

The cloud-init script will take the following actions. You can see [cloud-init output logs](https://cloudinit.readthedocs.io/en/20.1/topics/logging.html) at `var/log/cloud-init-output.log`.
Check progress in Linux 7.9 using ```sudo grep cloud-init /var/log/messages```

- Add CPQ authentication credentials to management agent wallet specified by ```cpq_username``` and ```cpq_pwd```.
- Create credentials json file. After deploying plug-ins on a Management Agent, [configure source credentials](https://docs.oracle.com/en-us/iaas/management-agents/doc/management-agents-administration-tasks.html#OCIAG-GUID-53567BB0-60B9-40DF-BB6A-A24BF825046F) to allow the agent to collect data from different sources
See examples of Logging Analytics [Credential JSON](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/set-rest-api-log-collection.html#GUID-FB61C7AC-F378-4F9B-9DD8-5D94ED272514__SECTION_M35_CQ2_QYB) files.

```json
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
```
- [Update credentials](https://docs.oracle.com/en-us/iaas/management-agents/doc/management-agents-administration-tasks.html#OCIAG-GUID-BE75E867-E2AC-4D1B-873F-3AD86546E7E3) calling ```credential_mgmt.sh``` with ```upsertCredentials``` argument and credentials JSON file.
- Check response if credentials script is available and management agent installed.
- Delete credentials json file when complete.

## Logging Analytics Identity and Access Management (IAM)

As a prerequisite to running this integration, perform these configuration tasks in your OCI tenancy.

- [Enable Access from Logging Analytics to Its Features Family](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/enable-access-logging-analytics-and-its-resources.html#GUID-ED43FF04-F65E-4599-B609-D35C5A197BF3)
- [Identify OCI Compartments to Place the Logging Analytics Resources](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/enable-access-logging-analytics-and-its-resources.html#GUID-48E4BACA-99BE-4955-9C5D-D52DE739C102)
- [Create User Groups to Implement Access Control](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/enable-access-logging-analytics-and-its-resources.html#LOGAN-GUID-C6F7BD2E-060D-475F-AA4A-3A2320BF5636)

  It is recommended that you create the user groups similar to the following examples to get started:
  - **Logging-Analytics-Users**: The users that you add to this group will be able to query the logs and see various configurations. However, they cannot enable or disable log collection, change configurations, or delete logs.
  - **Logging-Analytics-Admins**: The users that you add to this group will have Logging-Analytics-Users privileges and additionally can create or edit sources, parsers, entities, and log groups. These users can also enable or disable log collection. However, they cannot purge logs.
  - **Logging-Analytics-SuperAdmins**: The users in this group have the privileges of Logging-Analytics-Admins and can additionally perform lifecycle activities such as onboarding and offboarding from Oracle Logging Analytics, and purging logs.

- [Grant Access to User Groups](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/enable-access-logging-analytics-and-its-resources.html#LOGAN-GUID-EEB0A32F-9D33-4CF6-9FE7-F254C92BB2C0)
- [Allow Continuous Log Collection Using Management Agents](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/allow-continuous-log-collection-using-management-agents.html#LOGAN-GUID-AA23C2F5-6046-443C-A01B-A507E3B5BFB2)
  - Create a dynamic group for the Management Agent if it already doesn't exist, for example `Management-Agent-Dynamic-Group`. See [allow continuous log collection using management agent dynamic groups](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/oracle-defined-policy-templates-common-use-cases.html#GUID-9FEC5466-DC1C-4D57-8761-8D70CAF46F10__SECTION_EY2_ZJK_3CC)

  ```ALL {resource.type='managementagent', resource.compartment.id='<management_agent_compartment_OCID>'}```

  Create IAM policies for `Management-Agent-Dynamic-Group` to enable log collection and metrics generation:

  ```ALLOW DYNAMIC-GROUP Management-Agent-Dynamic-Group TO USE METRICS IN TENANCY```

  ```ALLOW DYNAMIC-GROUP Management-Agent-Dynamic-Group TO {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} IN TENANCY```

- [Enable Logging Analytics](https://docs.oracle.com/en-us/iaas/logging-analytics/doc/enable-access-logging-analytics-and-its-resources.html#LOGAN-GUID-EA2F6910-878F-483E-A36D-E880D7C2D5E3)

## Management Agent Troubleshooting

You can review and [troubleshoot](https://docs.oracle.com/en-us/iaas/management-agents/doc/troubleshoot-management-agents.html) typical issues and resolutions related to the Management Agents service, such as installing, and deinstalling with Management Agents. 

- Generate Management Agent diagnostic support bundle

```sudo -u oracle-cloud-agent /var/lib/oracle-cloud-agent/plugins/oci-managementagent/polaris/agent_inst/bin/generateDiagnosticBundle.sh```

- Check agent wallet contents

```sudo -u oracle-cloud-agent bash /var/lib/oracle-cloud-agent/plugins/oci-managementagent/polaris/agent_inst/bin/credential_mgmt.sh -s logan -o listCredentials```

- View agent log directory

```cd /var/lib/oracle-cloud-agent/plugins/oci-managementagent/polaris/agent_inst/log```
```tail mgmt_agent_logan.log```

- View agent configuration directory

```cd /var/lib/oracle-cloud-agent/plugins/oci-managementagent/polaris/agent_inst/config```

- View agent utilities directory

```cd /var/lib/oracle-cloud-agent/plugins/oci-managementagent/polaris/agent_inst/bin```

## Contributing

This project welcomes contributions from the community. Before submitting a pull request, please [review our contribution guide](./CONTRIBUTING.md)

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process

## License
Copyright (c) 2025, Oracle and/or its affiliates.
Released under the Universal Permissive License v1.0 as shown at <https://oss.oracle.com/licenses/upl/>.

## Distribution
 
Developers choosing to distribute a binary implementation of this project are responsible for obtaining and providing all required licenses and copyright notices for the third-party code used in order to ensure compliance with their respective open source licenses.