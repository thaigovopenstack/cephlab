#!/bin/bash
conf="/etc/chrony.conf"
sed -i.back '3,6d' $conf
sed -i '3i server 10.10.10.10  iburst' $conf

sudo systemctl restart chronyd
sleep 3
chronyc sources
