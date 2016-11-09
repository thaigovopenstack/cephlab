#!/bin/bash


mons='mon1 mon2 mon3'
osds='osd1 osd2 osd3 osd4'
sudo yum -y install ceph-deploy



mkdir ~/ceph-cluster
cd ~/ceph-cluster

echo "Install monitor node"
echo "===================="
ceph-deploy new $mons
cat <<CEPH >> ceph.conf
public network = 192.168.10.0/24
cluster network = 192.168.20.0/24
osd pool default size = 2
osd pool default min size = 1
osd pool default pg num = 256
osd pool default pgp num = 256
osd crush chooseleaf type = 1
CEPH

echo "ceph.conf detail"
echo "===================="
cat ceph.conf
echo "Install Ceph package"
echo "===================="
ceph-deploy install adminnode
ceph-deploy install $mons $osds
echo "create monitor node"
echo "===================="
ceph-deploy mon create-initial
ceph-deploy gatherkeys mon1

echo "list keyrings"
echo "============="
ls -l *.keyring

echo "prepare directory for storage rather than disk"
echo "=============================================="
echo "ssh osd1 sudo mkdir /storage1"
echo "ssh osd2 sudo mkdir /storage2"
echo "ssh osd3 sudo mkdir /storage3"
echo "ssh osd4 sudo mkdir /storage4"


ssh osd1 sudo mkdir /storage1
ssh osd2 sudo mkdir /storage2
ssh osd3 sudo mkdir /storage3
ssh osd4 sudo mkdir /storage4

#prepare directory
ceph-deploy osd prepare osd1:/storage1
ceph-deploy osd prepare osd2:/storage2
ceph-deploy osd prepare osd3:/storage3
ceph-deploy osd prepare osd4:/storage4

#fix permision
ssh osd1 sudo chown ceph:ceph /storage1
ssh osd2 sudo chown ceph:ceph /storage2
ssh osd3 sudo chown ceph:ceph /storage3
ssh osd4 sudo chown ceph:ceph /storage4

#activate
ceph-deploy osd activate osd1:/storage1
ceph-deploy osd activate osd2:/storage2
ceph-deploy osd activate osd3:/storage3
ceph-deploy osd activate osd4:/storage4



echo "Deploy key to everynode"
echo "======================="
echo "Use ceph-deploy to copy the configuration file and admin key"
echo "to your admin node and your Ceph Nodes"
echo ""
echo "ceph-deploy admin {admin-node} {ceph-node}"
echo ""

ceph-deploy install --cli adminnode
ceph-deploy admin adminnode mon1 mon2 mon3 osd1 osd2 osd3 osd4
echo "change permission"
sudo chmod +r /etc/ceph/ceph.client.admin.keyring

echo "test"
ceph -s


#echo "10GiB journal, 2 (normal _and_ minimum) replicas per object"

#cat << EOF >> ceph.conf.test
#osd_journal_size = 10000
#osd_pool_default_size = 2
#osd_pool_default_min_size = 2
#osd_crush_chooseleaf_type = 1
#osd_crush_update_on_start = true
#max_open_files = 131072
#osd pool default pg num = 128
#osd pool default pgp num = 128
#mon_pg_warn_max_per_osd = 0
#EOF
