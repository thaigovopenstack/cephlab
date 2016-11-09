#!/bin/bash
gensshkey(){
   ssh-keygen -f ~/.ssh/id_rsa  -t rsa -b 4096 -N ''
}

passwordless(){
hosts="adminnode mds1 mds2 mon1 mon2 mon3 osd1 osd2 osd3 osd4"
for i in $hosts;do
    echo "To -->  $i"
    ssh-keyscan $i >> ~/.ssh/known_hosts
    sshpass -f password.txt ssh-copy-id ceph-deploy@$i
done

for i in $hosts;do
    ssh $i hostname
done
}
echo "please switch user to ceph-deploy"

echo "Generate rsa key"
echo "==============="
echo ""
gensshkey
echo "copy ssh to host"
echo "==============="
echo ""
passwordless


