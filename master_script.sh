#!/bin/bash

cat <<HOST > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.10.5 adminnode.example.com adminnode
192.168.10.11 mds1.example.com mds1
192.168.10.12 mds2.example.com mds2
192.168.10.21 mon1.example.com mon1
192.168.10.22 mon2.example.com mon2
192.168.10.23 mon3.example.com mon3
192.168.10.31 osd1.example.com osd1
192.168.10.32 osd2.example.com osd2
192.168.10.33 osd3.example.com osd3
192.168.10.34 osd4.example.com osd4

HOST

echo "root:linux" | chpasswd
echo "keepcache = 1" >> /etc/yum.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
setenforce 0
echo "vagrant ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
sed -i.orgi "s/PasswordAuthentication no/PasswordAuthentication yes/g"    /etc/ssh/sshd_config
systemctl restart sshd

cat <<PID >> /etc/sysctl.conf
kernel.pid_max = 4194303
PID
sysctl -p
echo "cat /proc/sys/kernel/pid_max"
cat /proc/sys/kernel/pid_max
echo "============================"

cephrelease="jewel"
distro="el7"
basearch="x86_64"

cat <<DNS > /etc/resolv.conf
nameserver 8.8.8.8
DNS



cat <<REPO > /etc/yum.repos.d/ceph.repo
[ceph]
name=Ceph packages for $basearch
baseurl=https://download.ceph.com/rpm-${cephrelease}/${distro}/$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-${cephrelease}/${distro}/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=https://download.ceph.com/rpm-${cephrelease}/${distro}/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
REPO

echo "install sshpass epel-relase and update"
echo "======================================"

yum install -y epel-release
yum install -y sshpass 
yum update -y


echo "add user ceph-deploy with sudo"
echo "=============================="
echo ""
adduser ceph-deploy
echo linux | passwd ceph-deploy --stdin

cat << EOF > /etc/sudoers.d/ceph-deploy
ceph-deploy ALL = (root) NOPASSWD:ALL
Defaults:ceph-deploy !requiretty
EOF

chmod 440 /etc/sudoers.d/ceph-deploy


systemctl start firewalld
systemctl enable firewalld

echo "allow ports on admin 80/tcp 2003/tcp 4505-4506/tcp"
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=2003/tcp --permanent
firewall-cmd --zone=public --add-port=4505-4506/tcp --permanent

firewall-cmd --zone=public --add-port=6789/tcp --permanent
firewall-cmd --zone=public --add-port=6800-7300/tcp --permanent

firewall-cmd --reload
shutdown -r 0


