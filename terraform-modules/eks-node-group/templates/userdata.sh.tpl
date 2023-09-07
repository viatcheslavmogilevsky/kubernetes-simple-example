#!/bin/bash -xe

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' '${cluster_name}'

# Allow user supplied userdata code
echo "Node is up..."


