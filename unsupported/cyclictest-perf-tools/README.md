# cyclictest-perf-tools

> :heavy_exclamation_mark: *Red Hat does not provide commercial support for any of these tools or repos*

```bash
#############################################################################
DISCLAIMER: THESE ARE UNSUPPORTED COMMUNITY TOOLS.

THE REFERENCES ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#############################################################################
```

These instructions use code from [https://github.com/redhat-nfvpe/container-perf-tools](https://github.com/redhat-nfvpe/container-perf-tools)

## Instructions (using local/custom build)

1. `podman login mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443 -u dummy`
2. `git clone https://github.com/redhat-nfvpe/container-perf-tools/`
3. `cd container-perf-tools`
4. `podman build --file Dockerfile-cyclictest --tag cyclictest .`
5. `podman tag localhost/cyclictest:latest mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443/dummy/cyclictest:latest`
6. `podman push mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443/dummy/cyclictest:latest`
7. `podman images` you should see the image in Quay.
8. Modify any desired tunings in `rhocp-castor/unsupported/cyclictest-perf-tools/pod_cyclictest.yaml`
9. `oc create -f pod_cyclictest.yaml`

## Instruction (using upstream pre-built container image)

1. Pull upstream image

    ```bash
    podman pull quay.io/jianzzha/perf-tools:latest
    ```

2. Re-tag image for local regsitry

    ```bash
    podman tag quay.io/jianzzha/perf-tools:latest mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443/dummy/cyclictest:latest
    ```

3. Upload to local registry

    ```bash
    # login to registry
    podman login mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443 -u dummy
    # push image to registry
    podman push mgmtcluster-registry-quay-quay-enterprise.apps.nova.cars.lab:443/dummy/cyclictest:latest
    ```

## Gathering results

1. The results are dump to `stdout` of the Pod

    ```bash
    oc logs -n cyclictest cyclictest
    ```

## Re-running

1. Remove existing Pod `oc delete -f pod_cyclictest.yaml`
2. Modify any desired tunings in `pod_cyclictest.yaml`
3. Apply changes to `oc apply -f pod_cyclictest.yaml`
