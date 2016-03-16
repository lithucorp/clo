#!/bin/bash -ex
source config.cfg


ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Assign IP for Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# MGNT NETWORK
auto em1
iface em1 inet static
address $CON_MGNT_IP
netmask $NETMASK_ADD_MGNT


# EXT NETWORK
auto p255p1
iface p255p1 inet static
address $CON_EXT_IP
netmask $NETMASK_ADD_EXT
gateway $GATEWAY_IP_EXT
dns-nameservers 10.113.32.31
EOF


echo "Configuring hostname in CONTROLLER node"
sleep 3
echo "blrsrvosctl" > /etc/hostname
hostname -F /etc/hostname


echo "Configuring for file /etc/hosts"
sleep 3
iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost
cat << EOF >> $iphost
127.0.0.1       localhost
127.0.1.1       blrsrvosctl
$CON_MGNT_IP    blrsrvosctl
$COM1_MGNT_IP   blrsrvoscom1
$COM2_MGNT_IP   blrsrvoscom2


EOF


echo "##### Cai dat repos cho Liberty ##### "
apt-get install software-properties-common -y
add-apt-repository cloud-archive:liberty -y

sleep 5
echo "UPDATE PACKAGE FOR LIBERTY"
apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade

sleep 5

echo "Reboot Server"

#sleep 5
init 6
#


