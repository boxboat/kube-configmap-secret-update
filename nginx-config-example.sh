#!/bin/bash

cd $(dirname $0)

kubectl create configmap nginx-config-example-configmap \
    --from-file=admin.conf=./config/conf.d/admin.conf \
    --from-file=frontend.conf=./config/conf.d/frontend.conf \
    --dry-run -o yaml \
    | kubectl apply -f -

kubectl create secret generic nginx-config-example-secret \
    --from-file=htpasswd=./config/protected/htpasswd \
    --dry-run -o yaml \
    | kubectl apply -f -

export CONFIG_HASH=$(find ./config -type f | sort | xargs md5sum | md5sum | cut -d' ' -f 1)

envsubst '${CONFIG_HASH}' < nginx-config-example.yml \
    | kubectl apply -f -
