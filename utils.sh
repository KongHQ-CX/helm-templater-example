#!/bin/bash

installKongs() {
    # Gather all clusters
    readarray -t CLUSTERS < <(yq e '.clusters.*.alias | []' ./clusters.yaml)
}

$*