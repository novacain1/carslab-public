# Tear Down
```
export KUBECONFIG=kubeconfig-volt
oc delete managedcluster c3-cars-lab
oc delete bmh c3sno-c3-cars-lab -n c3-cars-lab
```

```
$ pwd
/home/user/carslab-public/rhocp-clusters/c3.cars.lab/ztp 
oc delete -k .
```

# Build up
```
$ pwd
/home/user/carslab-public/rhocp-clusters/c3.cars.lab/ztp 
oc create -f 00-namespace.yaml
oc create secret generic assisted-deployment-pull-secret -n c3-cars-lab --from-file=.dockerconfigjson=/home/user/pull-secret-fun/pull-secret-combined.json --type=kubernetes.io/dockerconfigjson
```

Make any modifications you would like here, be sure to submit any modifications as a PR!

```
oc create -k .
```

Watch the BMC for buildout, look at `oc get agent -o wide` output.  The cluster will start building in the background.

# Get Kubeconfig and Kubeadmin from resultant cluster

Once done you can use the generated kubeconfig and kubeadmin and access the new cluster:
```
export KUBECONFIG=kubeconfig-volt
oc get secret -n c3-cars-lab c3-cars-lab-admin-kubeconfig -o json | jq -r '.data.kubeconfig' | base64 -d > ~/kubeconfig-c3
oc get secret -n c3-cars-lab c3-cars-lab-admin-password -o json | jq -r '.data.password' | base64 -d > ~/kubeadmin-c3
```
