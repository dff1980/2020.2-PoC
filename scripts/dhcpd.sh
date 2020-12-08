#!/bin/sh
systemctl stop dhcpd.service

sed -i 's/^DHCPD_INTERFACE=".*"/DHCPD_INTERFACE="eth1"/' /etc/sysconfig/dhcpd

cat << EOF > /etc/dhcpd.conf
option domain-name "rancher.suse.ru";
option domain-name-servers 192.168.17.254, 8.8.8.8;
option routers 192.168.17.254;
option ntp-servers 192.168.17.254;
default-lease-time 14400;
ddns-update-style none;
subnet 192.168.17.0 netmask 255.255.255.0 {
  range 192.168.17.100 192.168.17.200;
  default-lease-time 14400;
  max-lease-time 172800;
}
EOF

systemctl enable dhcpd.service
systemctl start  dhcpd.service
