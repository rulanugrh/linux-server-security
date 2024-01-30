#!/bin/bash
systemctl enable firewall-cmd
systemctl start firewall-cmd
firewall-cmd --add-service=ftp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --zone=drop --add-service=dns --permanent
firewall-cmd --zone=truster --add-source=192.168.0.1/24 --permanent
systemctl restart firewall-cmd
