#!/bin/bash
testhost(){
hosts="adminnode mds1 mds2 mon1 mon2 mon3 osd1 osd2 osd3 osd4"
for i in $hosts;do
  if  ping -c 1 $i &>/dev/null
  then
     echo "host $i on"
  else
     echo "host $i off"
  fi
done
}
testhost

