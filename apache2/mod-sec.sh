#!/bin/bash
apt update -y
apt install libapache2-mod-security -y
cd /etc/modsecurity
mv modsecurity.conf-recommended modsecurity.conf
echo "SecRuleEngine On" >> modsecurity.conf
