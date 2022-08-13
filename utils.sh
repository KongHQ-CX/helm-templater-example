#!/bin/bash

installKongs() {
    CWD=$(pwd)

    # Render all tempates
    /usr/local/bin/kongtemplater

    # Set up Helm
    cd $CWD/chart-template
    helm repo add kong https://charts.konghq.com
    helm dep update

    cd $CWD
    # Gather all clusters to be installed
    for INSTALLATION in ./workdir/*
    do
      echo -e "\n\n**  Installing cluster configuration at $INSTALLATION **\n"
      cd $CWD/$INSTALLATION
      ./install-kong.sh
    done
}

$@
