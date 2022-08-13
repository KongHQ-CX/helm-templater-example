#!/bin/bash

echo 'IN: Install Kong'

echo '--> Setting Kube context'
kubectl config set-cluster azure-us
kubectl config set-context --current --namespace=konnect-rg-2

echo '--> Creating Kube secrets for clustering and proxy certificates'
kubectl -n konnect-rg-2 create secret tls konnect-certificate --cert="../../konnect-certificates/konnect-rg-2.pem" --key="../../konnect-certificates/konnect-rg-2.key"
kubectl -n konnect-rg-2 create secret tls kong-proxy-certificate --cert="../../proxy-certificates/konnect-rg-2-proxy.pem" --key="../../proxy-certificates/konnect-rg-2-proxy.key"

echo '--> Installing / Upgrading Helm chart with release name: konnect-rg-2'
helm upgrade -i konnect-rg-2 ../chart-template -f values.yaml

echo 'OUT: Install Kong'
