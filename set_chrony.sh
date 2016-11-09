#!/bin/bash
conf="/etc/chrony.conf"
sed -i.back '3,6d' $conf
sed -i '19i allow 10.10.10.0/24' $conf
sed -i '3i server 1.th.pool.ntp.org iburst' $conf
sed -i '4i server 0.asia.pool.ntp.org iburst' $conf
sed -i '5i server 2.asia.pool.ntp.org iburst' $conf 

sudo systemctl restart chronyd
sleep 3
sudo chronyc sources

hosts="mds1 mds2 mon1 mon2 mon3 osd1 osd2 osd3 osd4"
for i in $hosts;do
scp chrony-client.sh  ceph-deploy@${i}:/home/ceph-deploy
ssh $i /home/ceph-deploy/chrony-client.sh
done 
