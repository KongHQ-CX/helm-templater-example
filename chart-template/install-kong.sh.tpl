#!/bin/bash

echo 'IN: Install Kong'

echo '--> Setting Kube context'
kubectl config set-cluster {{ .KubeContext }}
kubectl config set-context --current --namespace={{ .Namespace }}

echo '--> Creating Kube secrets for clustering and proxy certificates'
kubectl -n {{ .Namespace }} create secret tls konnect-certificate --cert="../../{{ .KonnectCertificateFiles.Cert }}" --key="../../{{ .KonnectCertificateFiles.Key }}"
kubectl -n {{ .Namespace }} create secret tls kong-proxy-certificate --cert="../../{{ .ProxyCertificateFiles.Cert }}" --key="../../{{ .ProxyCertificateFiles.Key }}"

echo '--> Installing / Upgrading Helm chart with release name: {{ .Alias }}'
helm upgrade -i {{ .Alias }} ../chart-template -f values.yaml

echo 'OUT: Install Kong'
