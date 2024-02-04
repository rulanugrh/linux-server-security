#!/bin/bash

install_package_in_debian(){
    echo -e "Choose your package want install"
    echo -e "1. Install LAMP"
    echo -e "2. Install LNMP"
    echo -e "3. Install modsecurity apache2"
    echo -e "4. Install fail2ban"

    read -p "Choose your option: " option

    case $option in
        1) sudo apt install apache2 mariadb-server mariadb-client php -y
        ;;
        2) sudo apt install nginx mariadb-server mariadb-client php -y
        ;;
        3) sudo apt install libapache2-mod-security -y
        ;;
        4) sudo apt install fail2ban -y
        ;;
        *) echo "Sorry your option is not found"
        ;;
    esac
}

install_package_in_debian