# Telco Managment Cluster

The Telco management cluster *MUST* be OpenShift 4.8.19+ or higher and *MUST* be deployed using one of the following methods:
- Assisted Installer / Assisted Service Operator
- Baremetal IPI
- Crucible Ansible Playbooks (https://github.com/redhat-partner-solutions/crucible)

These method are the *ONLY* methods that deploy and configure the `cluster-baremetal-operator` in the cluster which is a requirement for some of the ZTP automation flows.

## EXAMPLES

The following are examples of Telco management clusters utilizing the `telco-gitops` (github.com/openshift-telco/telco-gitops) repository:

- https://github.com/openshift-telco/telco-gitops-mgmt
- https://github.com/redhat-partner-solutions/carslab-public/tree/main/rhocp-clusters/mgmt
