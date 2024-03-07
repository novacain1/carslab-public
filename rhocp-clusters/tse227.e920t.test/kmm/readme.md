# KMM driver work and output for CGNAT

# Pre-Built Instructions

## Get Driver Toolkit Digest for OpenShift version
```shell
$ oc adm release info 4.12.44 --image-for=driver-toolkit
quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:bbd15c05271b311110f598a254d8ee8260adb5c62af9e0f80da6a6e167d5539d
```

## Pull Driver Toolkit locally to use
```shell
$ podman pull --authfile ~/pull-secret-fun/pull-secret-2.json quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:bbd15c05271b311110f598a254d8ee8260adb5c62af9e0f80da6a6e167d5539d
```

## Create Driver Container with forked OOT ice.ko locally
```shell
$ export REGISTRY=quay.io/dcain
$ podman login -u dcain $REGISTRY 

$ podman build -f Containerfile-4.18.0-372.80.1.el8_6.x86_64 -t $REGISTRY/oot-ice-cgnat/oot-ice-cgnat:4.18.0-372.80.1.el8_6.x86_64 .
$ podman push $REGISTRY/oot-ice-cgnat/oot-ice-cgnat:4.18.0-372.80.1.el8_6.x86_64
```

## Load out of tree ice driver on ZTP cluster using KMM CR
This assumes irdma module is blacklisted like it is in the Telco DU Profile deployed by ZTP.
This assumes the cluster has read pull access from the remote registry.

```shell
$ oc create -f 01-kmm-module-prebuilt.yaml
```

## SSH to openshift node, look at driver
Use ssh or oc debug container.

```shell
[root@sno ~]# cat /sys/bus/pci/drivers/ice/module/version 
1.12.7_dirty
```

### dmesg output
```shell
[ 1256.117454] ice: module unloaded

[ 1256.177150] ice: loading out-of-tree module taints kernel.

[ 1256.177732] ice: module verification failed: signature and/or required key missing - tainting kernel
[ 1256.188632] ice: Intel(R) Ethernet Connection E800 Series Linux Driver - version 1.12.7_dirty
[ 1256.188653] ice: Copyright (C) 2018-2023 Intel Corporation
[ 1256.610873] ice 0000:10:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.26.0
[ 1256.661217] ice 0000:10:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1256.670370] ice 0000:10:00.0 ens1f0: renamed from eth0
[ 1256.671475] ice 0000:10:00.0: PTP init successful
[ 1256.833989] ice 0000:10:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1256.833994] ice 0000:10:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1256.834033] ice 0000:10:00.0: Commit DCB Configuration to the hardware
[ 1256.836628] ice 0000:10:00.0 ens1f0: A parallel fault was detected.
[ 1256.836672] ice 0000:10:00.0 ens1f0: Possible Solution: Check link partner connection and configuration.
[ 1256.836692] ice 0000:10:00.0 ens1f0: Port Number: 3.
[ 1256.844277] IPv6: ADDRCONF(NETDEV_UP): ens1f0: link is not ready
[ 1257.048572] ice 0000:10:00.1: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1257.097668] ice 0000:10:00.1: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1257.195394] IPv6: ADDRCONF(NETDEV_UP): ens1f0: link is not ready
[ 1257.233207] ice 0000:10:00.1: PTP init successful
[ 1257.285157] ice 0000:10:00.1 ens1f1: renamed from eth0
[ 1257.488607] ice 0000:10:00.1: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1257.488624] ice 0000:10:00.1: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1257.488663] ice 0000:10:00.1: Commit DCB Configuration to the hardware
[ 1257.780207] ice 0000:10:00.2: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1257.889169] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready
[ 1258.020064] ice 0000:10:00.2: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1258.079089] ice 0000:10:00.1 ens1f1: NIC Link is up 25 Gbps Full Duplex, Requested FEC: RS-FEC, Negotiated FEC: RS-FEC, Autoneg Advertised: Off, Autoneg Negotiated: False, Flow Control: None
[ 1258.081005] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready
[ 1258.091713] ice 0000:10:00.2: PTP init successful
[ 1258.092619] ice 0000:10:00.2 ens1f2: renamed from eth0
[ 1258.289433] ice 0000:10:00.2: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1258.289437] ice 0000:10:00.2: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1258.289474] ice 0000:10:00.2: Commit DCB Configuration to the hardware
[ 1258.291503] ice 0000:10:00.2 ens1f2: Module is not present.
[ 1258.291554] ice 0000:10:00.2 ens1f2: Possible Solution 1: Check that the module is inserted correctly.
[ 1258.291566] ice 0000:10:00.2 ens1f2: Possible Solution 2: If the problem persists, use a cable/module that is found in the supported modules and cables list for this device.
[ 1258.291577] ice 0000:10:00.2 ens1f2: Port Number: 2.
[ 1258.294824] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready
[ 1258.296720] IPv6: ADDRCONF(NETDEV_UP): ens1f2: link is not ready
[ 1258.433094] ice 0000:10:00.3: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1258.435985] IPv6: ADDRCONF(NETDEV_UP): ens1f2: link is not ready
[ 1258.472758] device ens1f1 entered promiscuous mode
[ 1258.484996] ice 0000:10:00.3: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1258.504414] ice 0000:10:00.3 ens1f3: renamed from eth0
[ 1258.507069] ice 0000:10:00.3: PTP init successful
[ 1258.683965] ice 0000:10:00.3: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1258.683970] ice 0000:10:00.3: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1258.684008] ice 0000:10:00.3: Commit DCB Configuration to the hardware
[ 1258.686732] ice 0000:10:00.3 ens1f3: Module is not present.
[ 1258.686748] ice 0000:10:00.3 ens1f3: Possible Solution 1: Check that the module is inserted correctly.
[ 1258.686753] ice 0000:10:00.3 ens1f3: Possible Solution 2: If the problem persists, use a cable/module that is found in the supported modules and cables list for this device.
[ 1258.686757] ice 0000:10:00.3 ens1f3: Port Number: 0.
[ 1258.692009] IPv6: ADDRCONF(NETDEV_UP): ens1f3: link is not ready
[ 1258.856750] IPv6: ADDRCONF(NETDEV_UP): ens1f3: link is not ready
[ 1258.856803] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[ 1259.150954] ice 0000:12:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.26.0
[ 1259.215631] ice 0000:12:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:04.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1259.225259] ice 0000:12:00.0 ens2f0: renamed from eth0
[ 1259.228515] ice 0000:12:00.0: PTP init successful
[ 1259.391199] ice 0000:12:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1259.391204] ice 0000:12:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1259.391243] ice 0000:12:00.0: Commit DCB Configuration to the hardware
[ 1259.393727] ice 0000:12:00.0 ens2f0: A parallel fault was detected.
[ 1259.393765] ice 0000:12:00.0 ens2f0: Possible Solution: Check link partner connection and configuration.
[ 1259.393777] ice 0000:12:00.0 ens2f0: Port Number: 3.
[ 1259.417502] IPv6: ADDRCONF(NETDEV_UP): ens2f0: link is not ready
[ 1259.529110] ice 0000:12:00.1: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1259.576646] ice 0000:12:00.1: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:04.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1259.585621] IPv6: ADDRCONF(NETDEV_UP): ens2f0: link is not ready
[ 1259.589570] ice 0000:12:00.1: PTP init successful
[ 1259.593457] ice 0000:12:00.1 ens2f1: renamed from eth0
[ 1259.761087] ice 0000:12:00.1: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1259.761091] ice 0000:12:00.1: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1259.761134] ice 0000:12:00.1: Commit DCB Configuration to the hardware
[ 1259.767091] IPv6: ADDRCONF(NETDEV_UP): ens2f1: link is not ready
[ 1259.901492] ice 0000:12:00.2: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1259.918424] ice 0000:12:00.1 ens2f1: NIC Link is up 25 Gbps Full Duplex, Requested FEC: RS-FEC, Negotiated FEC: RS-FEC, Autoneg Advertised: Off, Autoneg Negotiated: False, Flow Control: None
[ 1259.993976] ice 0000:12:00.2: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:04.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1260.006965] ice 0000:12:00.2 ens2f2: renamed from eth0
[ 1260.010281] ice 0000:12:00.2: PTP init successful
[ 1260.191794] ice 0000:12:00.2: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1260.191799] ice 0000:12:00.2: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1260.191838] ice 0000:12:00.2: Commit DCB Configuration to the hardware
[ 1260.205413] ice 0000:12:00.2 ens2f2: Module is not present.
[ 1260.205461] ice 0000:12:00.2 ens2f2: Possible Solution 1: Check that the module is inserted correctly.
[ 1260.205473] ice 0000:12:00.2 ens2f2: Possible Solution 2: If the problem persists, use a cable/module that is found in the supported modules and cables list for this device.
[ 1260.205484] ice 0000:12:00.2 ens2f2: Port Number: 2.
[ 1260.207581] IPv6: ADDRCONF(NETDEV_UP): ens2f2: link is not ready
[ 1260.345329] ice 0000:12:00.3: DDP package already present on device: ICE OS Default Package version 1.3.26.0
[ 1260.384332] IPv6: ADDRCONF(NETDEV_UP): ens2f2: link is not ready
[ 1260.397491] device ens1f1 left promiscuous mode
[ 1260.406517] ice 0000:12:00.3: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:0f:04.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[ 1260.428034] device ens1f1 entered promiscuous mode
[ 1260.434876] ice 0000:12:00.3: PTP init successful
[ 1260.485239] ice 0000:12:00.3 ens2f3: renamed from eth0
[ 1260.688961] ice 0000:12:00.3: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[ 1260.688965] ice 0000:12:00.3: FW LLDP is disabled, DCBx/LLDP in SW mode.
[ 1260.689004] ice 0000:12:00.3: Commit DCB Configuration to the hardware
[ 1260.691201] ice 0000:12:00.3 ens2f3: Module is not present.
[ 1260.691261] ice 0000:12:00.3 ens2f3: Possible Solution 1: Check that the module is inserted correctly.
[ 1260.691279] ice 0000:12:00.3 ens2f3: Possible Solution 2: If the problem persists, use a cable/module that is found in the supported modules and cables list for this device.
[ 1260.691290] ice 0000:12:00.3 ens2f3: Port Number: 0.
```

## Unloading module
Note that this currently removes the ice driver module completely.  if you only have 800 series intel NICs, this essentially removes network access from the node.
```shell
oc delete -f 01-kmm-module.yaml
```
