#!/bin/bash

echo 'IN: Install Kong'

echo '--> Setting Kube context'
kubectl config set-cluster azure-eu
kubectl config set-context --current --namespace=konnect-rg-1

echo '--> Creating Kube secrets for clustering and proxy certificates'
kubectl -n konnect-rg-1 create secret tls konnect-certificate --cert="../../konnect-certificates/cluster.crt" --key="../../konnect-certificates/cluster.key"
kubectl -n konnect-rg-1 create secret tls kong-proxy-certificate --cert="../../proxy-certificates/konnect-rg-1-proxy.pem" --key="../../proxy-certificates/konnect-rg-1-proxy.key"

echo '--> Installing / Upgrading Helm chart with release name: konnect-rg-1'
helm upgrade -i konnect-rg-1 ../chart-template -f values.yaml

echo 'OUT: Install Kong'
all Kong'
