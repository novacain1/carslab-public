# Launching the workload

The L1 reference workload can be launched by doing the following.  This takes care of necessary service accounts, permissions, and it launches as a Deployment in OpenShift.  Be sure the registry you are pulling the workload to is contained in your Global Pull Secret, if the registry requires authentication.

```
oc apply -f flexran_timer_mode.yaml
```

# Copying necessary configuration files

The XML files for configuration in the pod need to be modified.  The workload does not have a Kubernetes native way of modifying values, and so defaults are used in the pod (through workload compilation) which must be overwritten.

```
./flexran_copy-icx.sh
```

# Executing L1 process in the workload to start Timer mode

The L1 reference workload must have both L1 and L2 processes started manually.  Do the following to start the L1 process:

```
oc rsh flexran-binary-release
cd bin/nr5g/gnb/l1
./l1.sh -e
```

# Executing L2 process in the workload to execute the variable throughput test case

Open a new command line window so you can watch both the L1 and L2 consoles that the workload provides.  The L1 reference workload must also have the L2 process started, after the L1 process is started.

```
oc rsh flexran-binary-release
cd bin/nr5g/gnb/testmac
./l2.sh --testfile=traffic_profile/testmac_power.cfg
```
