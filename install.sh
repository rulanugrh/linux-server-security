#!/bin/bash

source ./util/centos.sh
source ./util/debian.sh

check_os_version() {
    . /etc/os-release
    case $ID in
        ubuntu|debian) install_package_in_debian
        ;;
        centos) install_package_in_centos
        ;;
        *) echo "Sabar, sedang tahap pembuatan"
        ;;
    esac
}

check_os_version