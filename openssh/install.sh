#!/bin.bash

install_open_ssh(){
    . /etc/os-release
    case $ID in
        ubuntu|debian) sudo apt install openssh-server -y
        ;;
        alpine) sudo apk add openssh
        ;;
        centos) sudo yum install openssh-server
        ;;
        *) echo "cant install because your version os not in my script"
        ;;
    esac
}

install_open_ssh