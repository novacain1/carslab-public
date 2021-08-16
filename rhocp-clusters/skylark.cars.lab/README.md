# SKYLARK

Skylark is a RAN workload cluster.

## Networks
Domain: skylark.cars.lab


| IP or CIDR     | USAGE        |
|----------------|:-------------|
| 10.50.0.0/24   | Cluster CIDR |
| 10.50.0.98     | apiVIP       |
| 10.50.0.99     | ingressVIP   |
| 10.50.0.100    | Reserved     |

## Nodes
| SERVER   | FQDN                       | LABEL        | NODE IP      | SERVICE TAG | BMC IP        | LOCATION  |
|----------|----------------------------|--------------|--------------|-------------|---------------|-----------|
| CU1      | cu1.skylark.cars.lab       | R740 XL      | 10.50.0.151  | B51VJ93     | 172.28.11.34  | LDC1      |
| CU2      | cu2.skylark.cars.lab       | R740 XL      | 10.50.0.152  | B51TJ93     | 172.28.11.35  | LDC1      |
| DU1-LDC1 | du1-ldc1.skylark.cars.lab  | R740 XL      | 172.16.0.101 | B53TJ93     | 172.28.11.36  | LDC1      |
| DU2-LDC1 | du2-ldc2.skylark.cars.lab  | R740 XL      | 172.16.0.102 | B52YJ93     | 172.28.11.37  | LDC1      |
| DU3-LDC1 | du3-ldc2.skylark.cars.lab  | R740 XL      | 172.16.0.103 | B52ZJ93     | 172.28.11.38  | LDC1      |
| DU1-FEC1 | du1-fec1.skylark.cars.lab  | SMCI X11SPW  | 172.18.0.151 |             | 172.28.11.39  | FEC1      |
| DU1-FEC2 | du1-fec2.skylark.cars.lab  | SMCI X11SPW  | 172.19.0.151 |             | 172.28.11.40  | FEC2      |
| DU1-FEC3 | du1-fec3.skylark.cars.lab  | Dell XR12    | 172.20.0.151 |             | 172.28.11.41  | FEC3      |


## Control Plane
OpenShift Control Plane for cluster

| Supervisors              | MAC               | IP           | CONFIG                     |
|--------------------------|-------------------|--------------|------------------------------------------|
| super1.skylark.cars.lab  | 52:52:00:11:44:11 | 10.50.0.101  | 96 vCPU, 192G RAM, 2*480 SSD, 2x1.6 NVMe |
| super2.skylark.cars.lab  | 52:52:00:11:44:12 | 10.50.0.102  | 96 vCPU, 192G RAM, 2*480 SSD, 2x1.6 NVMe |
| super3.skylark.cars.lab  | 52:52:00:11:44:13 | 10.50.0.103  | 96 vCPU, 192G RAM, 2*480 SSD, 2x1.6 NVMe |

# General Notes

``` oc kustomize . ``` to examine what would be applied.
``` oc apply -k . ``` to apply manifests using Kustomize in this directory.

## Deployment
