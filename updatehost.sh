#!/bin/bash
hosts="adminnode mds1 mds2 mon1 mon2 mon3 osd1 osd2 osd3 osd4"
for i in $hosts; do ssh $i  sudo  yum update -y ;done
