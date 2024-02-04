#!/bin.bash

install_package_in_centos(){
    echo -e "Choose your package want install"
    echo -e "1. Install LAMP"
    echo -e "2. Install LNMP"
    echo -e "3. Install modsecurity apache2"
    echo -e "4. Install fail2ban"

    read -p "Choose your option: " option

    case $option in
        1) sudo dnf install httpd mariadb-server mariadb-client php php-mysqlnd
        ;;
        2) sudo dnf install nginx mariadb-server mariadb-client php
        ;;
        3) sudo dnf install mod_security
        ;;
        4) sudo dnf install fail2ban -y
        ;;
        *) echo "Sorry your option is not found"
        ;;
    esac
}