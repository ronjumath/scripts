#!/bin/bash
#ReplicaSet with mongodb 3.4 and Ubuntu 16.04

if [ $EUID != 0 ]
  then echo "Run the script as root"
  exit
fi

clear

priHost=$3
arbHost=$4
localhost=`hostname -f`

sh install.sh $1

for host in $(echo "$2" | sed "s/,/ /g")
do
  if [ $host != $localhost ]; then
    scp install.sh devops@$host:/tmp && ssh -t devops@$host sudo -s "/tmp/install.sh $1"
  fi
done

mongo $priHost --eval "printjson(rs.initiate('$prihost'))"

mongo $priHost --eval "printjson(rs.addArb('$arbHost'))"

for node in $(echo "$2" | sed "s/,/ /g")
do
  if [ $node != $priHost ] && [ $node != $arbHost ]; then
    mongo $priHost --eval "printjson(rs.add('$node'))"
  fi
done
