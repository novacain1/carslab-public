# NOVA

NOVA is a Management cluster.

## Networks
Domain: nova.cars.lab

| IP or CIDR     | USAGE        |
|----------------|:-------------|
| 10.60.0.0/24   | Cluster CIDR |
| 10.60.0.96     | apiVIP       |
| 10.60.0.97     | ingressVIP   |

## Nodes
| SERVER   | FQDN                       | LABEL        | NODE IP      | SERVICE TAG | BMC IP        | LOCATION  |
|---------|-------------------------|--------------|--------------|-------------|---------------|-----------|
| WORKER1 | worker1.nova.cars.lab   | R740 XL      | 10.60.0.151  | B53XJ93     | 172.28.11.25  | CDC1      |
| WORKER2 | worker2.nova.cars.lab   | R740 XL      | 10.60.0.152  | B537J93     | 172.28.11.26  | CDC1      |
| WORKER3 | worker3.nova.cars.lab   | R740 XL      | 10.68.0.153  | B53VJ93     | 172.28.11.27  | CDC1      |
| WORKER4 | worker4.nova.cars.lab   | R740 XL      | 10.68.0.154  | B54TJ93     | 172.28.11.28  | CDC1      |
| WORKER5 | worker5.nova.cars.lab   | R740 XL      | 10.68.0.155  | B53WJ93     | 172.28.11.29  | CDC1      |
| WORKER6 | worker6.nova.cars.lab   | R740 XL      | 10.60.0.156  | B53ZJ93     | 172.28.11.30  | CDC1      |


## Control Plane
OpenShift Control Plane for cluster

| Supervisors           | MAC               | IP           | CONFIG                                   |
|-----------------------|-------------------|--------------|------------------------------------------|
| super1.nova.cars.lab  | 40:A6:B7:51:A1:00 | 10.60.0.101  | 96 vCPU, 192G RAM, 2*480 SSD, 6x3.2 NVMe |
| super2.nova.cars.lab  | 40:A6:B7:51:89:70 | 10.60.0.102  | 96 vCPU, 192G RAM, 2*480 SSD, 6x3.2 NVMe |
| super3.nova.cars.lab  | 40:A6:B7:51:89:20 | 10.60.0.103  | 96 vCPU, 192G RAM, 2*480 SSD, 6x3.2 NVMe |
