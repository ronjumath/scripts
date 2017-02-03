#!/bin/bash
#ReplicaSet with mongodb 3.4 and Ubuntu 16.04

dbPath=/data
mongoUser=mongodb

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
apt-get update
apt-get install -y mongodb-org

mkdir $dbPath
chown $mongoUser:$mongoUser $dbPath

sed -i "s|/var/lib/mongodb|$dbPath|" /etc/mongod.conf
sed -i "s|bindIp: 127.0.0.1|#bindIp: 127.0.0.1|" /etc/mongod.conf
echo "replication:" >> /etc/mongod.conf
echo "  replSetName: $1" >> /etc/mongod.conf

systemctl start mongod
systemctl enable mongod

