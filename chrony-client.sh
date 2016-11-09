#!/bin/bash
conf="/etc/chrony.conf"
sudo sed -i.back '3,6d' $conf
sudo sed -i '3i server 192.168.10.5 iburst' $conf

sudo systemctl restart chronyd
sleep 3
sudo chronyc sources
