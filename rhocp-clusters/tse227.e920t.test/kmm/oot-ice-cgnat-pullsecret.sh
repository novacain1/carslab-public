oc create secret generic oot-ice-cgnat-pullsecret --from-file=.dockerconfigjson=/run/user/1000/containers/auth.json --type=kubernetes.io/dockerconfigjson
