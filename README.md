# SUSE Rancher 2020 PoC #2

This project is PoC installation Rancher at SLES.

Using version:
- RKE
- Rancher 2.x
- SLES 15 SP2

This document currently in development state. Any comments and additions are welcome.
If you need some additional information about it please contact with Pavel Zhukov (pavel.zhukov@suse.com).

###### Disclaimer
###### _At the moment, no one is responsible if you try to use the information below for productive installations or commercial purposes._

## PoC Landscape
PoC can be deployed in any virtualization environment or on hardware servers.
Currently, PoC hosted on VMware VSphere.

## Requarments

### Tech Specs
- 1 dedicated infrastructure server ( DNS, DHCP, PXE, NTP, NAT, SMT, TFTP, RKE admin, Rancher admin)
    
    4GB RAM
    
    1 x HDD - 160GB
    
    1 LAN adapter
    
    1 WAN adapter

- 1 x RKE for Rancher Server Nodes
  
  - 1 x  Node (Up to 3  nodes)
  
     8 GB RAM
  
     1 x HDD 100 GB (50 GB+)
  
     1 LAN (Minimum 1Gb/s)
  
- 4 x RKE Node for demo
    
     32 GB RAM
     
     4 x HDD 100 GB
     
     1 LAN

### Network Architecture
All server connect to LAN network (isolate from another world). In current state - 192.168.17.0/24.
Infrastructure server also connects to WAN.

## Install Router
Install SLES with DNS/DHCP

## Configure Router
```
zypper in git-core
git clone https://github.com/dff1980/2020.2-PoC/
```
#### 1. Configure Chrony
```

./chrony.sh
```
#### 2. Configure DHCPD
```
./dhcpd.sh
```
#### 3. Configure DNS
```
./named.sh
```
#### 4. Configure Firewall
```
./firewall.sh
```

#### 5. Configure RMT.
```bash
sudo zypper in -y rmt-server
```
Execute RMT configuration wizard. During the server certificate setup, all possible DNS for this server has been added (RMT FQDN, etc).
```
yast rmt
```
Add repositories to replication.
```bash
./rmt-mirror.sh
rmt-cli mirror
```

## Configure Node Teamplate
Install minimal SLES system
```
systemctl stop firewalld.service
systemctl disable firewalld.service
```
Install docker
```
usermod -aG docker <user_name>
```
```
systemctl enable docker.service
systemctl start docker.service
```

In the file /etc/sysctl.conf add the following lines:
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
add file /etc/modules-load.d/modules-rancher.conf
```
br_netfilter
ip6_udp_tunnel
ip_set_hash_ip
ip_set_hash_net
iptable_filter
iptable_nat
iptable_mangle
iptable_raw
nf_conntrack_netlink
nf_conntrack
nf_conntrack_ipv4
nf_defrag_ipv4
nf_nat
nf_nat_ipv4
nf_nat_masquerade_ipv4
udp_tunnel
veth
vxlan
xt_addrtype
xt_conntrack
xt_comment
xt_mark
xt_multiport
xt_nat
xt_recent
xt_set
xt_statistic
xt_tcpudp
```
add file /etc/sysctl.d/90-rancher.conf
```
net.bridge.bridge-nf-call-iptables=1
```
change file /etc/ssh/sshd_config
```
AllowTcpForwarding yes
```

```
SUSEConnect --product sle-module-public-cloud/15.2/x86_64
zypper in -y cloud-init
systemctl enable cloud-init-local.service
systemctl enable cloud-init.service
systemctl enable cloud-config.service
systemctl enable cloud-final.service

sudo zypper install -y clone-master-clean-up
clone-master-clean-up
```

