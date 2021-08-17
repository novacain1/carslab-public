# Telco Managment Cluster

The Telco management cluster must be OCP 4.8.x and be deployed using one of the following methods:
- Assisted Installer / OpenShift Infrastructure Operator mode
- Baremetal IPI mode

These method are the only methods that deploy and configure the `cluster-baremetal-operator` in the cluster which is a requirement for some of the automation flows.

## Instructions

Once the cluster is deployed using one of the valid deployment methods for Telco Management Clusters, it's time to configure it.  Be sure to reference the appripriate KUBECONFIG and the path of this repository, which you should have cloned to a path appropriate to your environment.  The `oc kustomize` command will show you what will be applied.  Example is below:

```bash
export KUBECONFIG=~/kubeconfig-volt
export TELCO_MGMT_PATH=~/carslab-public/rhocp-clusters/volt.cars.lab
oc kustomize $TELCO_MGMT_PATH
```

- Sample run, be sure you are referencing the appropriate kubeconfig for the Management cluster here, which in our case is volt.cars.lab!

```bash
$ oc whoami --show-server
https://api.volt.cars.lab:6443

$ cd $TELCO_MGMT_PATH
$ oc apply -k .
Warning: resource namespaces/assisted-installer is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by oc apply. oc apply should only be used on resources created declaratively by either oc create --save-config or oc apply. The missing annotation will be patched automatically.
namespace/assisted-installer configured
namespace/open-cluster-management created
namespace/openshift-local-storage created
namespace/openshift-serverless created
clusterrole.rbac.authorization.k8s.io/openshift-gitops-custom-role created
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-group created
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-telcoadmin created
clusterrolebinding.rbac.authorization.k8s.io/openshift-gitops-custom-rolebinding created
...<snip>...
error: unable to recognize ".": no matches for kind "SriovOperatorConfig" in version "sriovnetwork.openshift.io/v1"
```

- You will see some warning messages and some "unable to recognize" and Error from server (Invalid) messages.  Run oc apply -k a few times.
- Disconnection for the ingressVIP and apiVIP might be experienced as the configuration is modifying the corresponding operator configuration. There is a rolling update that is also kickstarted by the chrony configuration wich will apply to nodes. After few minutes the base configuration sould be completed.

- Create secret from pull-secret for Assisted Installer Operator:

    ```bash
    oc create secret generic assisted-deployment-pull-secret -n assisted-installer \
    --from-file=.dockerconfigjson=pull-secret.json --type=kubernetes.io/dockerconfigjson
    ```

- Label OpenShift Supervisor nodes with the `ran.openshit.io/lso` label, so the Local Storage Operator consumes the second block device for the Openshift Infrastructure Operator storage needs:
```bash
oc label node super1 ran.openshift.io/lso=''
oc label node super2 ran.openshift.io/lso=''
oc label node super3 ran.openshift.io/lso=''
```

- Patch metal3 so it can see all the `bmh` resources in all namespaces:

    ```bash
    oc patch provisioning provisioning-configuration --type merge -p '{"spec":{"watchAllNamespaces": true}}'
    ```
- To obtain the password for `openshift-gitops` ArgoCD `admin`

    ```bash
    oc get secret openshift-gitops-cluster -o go-template='{{index .data "admin.password"}}' | base64 -d
    ```
- Set mgmt cluster definition via GitOps

    ```bash
    oc apply -f 00-mgmt-telco-base.yaml
    ```

## Definition of cluster for ArgoCD

After a cluster is deployed, before using ArgoCD for day-2 GitOps configurations, the cluster credentials must be defined in ArgoCD.

- Login into the ArgoCD instance in the management cluster using ArgoCD CLI. You will be prompted for the ArgoCD `admin` password.
```bash
argocd login https://api.volt.cars.lab:6443 --name admin
```
- List clusters
```bash
$ argocd cluster list
SERVER                                  NAME        VERSION  STATUS      MESSAGE
https://kubernetes.default.svc          in-cluster  1.21+    Successful
```
- Add target cluster
```bash
$ argocd cluster add --kubeconfig ~/kubeconfig-volt admin --name volt
INFO[0000] ServiceAccount "argocd-manager" created in namespace "kube-system"
INFO[0000] ClusterRole "argocd-manager-role" created
INFO[0000] ClusterRoleBinding "argocd-manager-role-binding" created
Cluster 'https://api.volt.cars.lab:6443' added
```
- Validate cluster has been defined
```bash
argocd cluster list
SERVER                                  NAME        VERSION  STATUS      MESSAGE
https://api.volt.cars.lab:6443          telco-core  1.20     Successful
https://kubernetes.default.svc          in-cluster  1.21+    Successful
```
## Context
Output from a working management cluster (Volt) from August 2021 with versions at the time:

$ oc get installplan -A
NAMESPACE                 NAME            CSV                                            APPROVAL    APPROVED
assisted-installer        install-ptttk   assisted-service-operator.v99.0.0-unreleased   Automatic   true
open-cluster-management   install-6brjw   advanced-cluster-management.v2.3.1             Automatic   true
openshift-local-storage   install-vxfqj   local-storage-operator.4.8.0-202107291502      Automatic   true
openshift-operators       install-dg82v   openshift-gitops-operator.v1.2.0               Automatic   true
openshift-serverless      install-vwt46   serverless-operator.v1.16.0                    Automatic   true

$ oc get operatorgroup -A
NAMESPACE                              NAME                           AGE
assisted-installer                     assisted-service-operator      151m
open-cluster-management                open-cluster-management        151m
openshift-local-storage                local-operator-group           151m
openshift-monitoring                   openshift-cluster-monitoring   4h7m
openshift-operator-lifecycle-manager   olm-operators                  4h7m
openshift-operators                    global-operators               4h7m
openshift-serverless                   openshift-serverless           151m
