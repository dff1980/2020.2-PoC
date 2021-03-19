# Using a pool of addresses in vApp in the sphere

https://www.virtualthoughts.co.uk/2020/03/29/rancher-vsphere-network-protocol-profiles-and-static-ip-addresses-for-k8s-nodes/

OVF environment transport: com.vmware.guestInfo

vApp IP protocol:  IPv4

vApp IP allocation policy: fixedAllocated

Key = Value

guestinfo.interface.0.ip.0.address = ip:PZhukov Rancher
 	
guestinfo.interface.0.ip.0.netmask = ${netmask:PZhukov Rancher}
 	
guestinfo.interface.0.route.0.gateway = ${gateway:PZhukov Rancher}
 	
guestinfo.dns.servers =	${dns:PZhukov Rancher}
 
## cloud-init for SLES 12 SP2
```
#cloud-config
write_files:
  - path: /tmp/network-setup.sh
    content: |
        #!/bin/bash
        vmtoolsd --cmd 'info-get guestinfo.ovfEnv' > /tmp/ovfenv
        IPAddress=$(sed -n 's/.*Property oe:key="guestinfo.interface.0.ip.0.address" oe:value="\([^"]*\).*/\1/p' /tmp/ovfenv)
        SubnetMask=$(sed -n 's/.*Property oe:key="guestinfo.interface.0.ip.0.netmask" oe:value="\([^"]*\).*/\1/p' /tmp/ovfenv)
        Gateway=$(sed -n 's/.*Property oe:key="guestinfo.interface.0.route.0.gateway" oe:value="\([^"]*\).*/\1/p' /tmp/ovfenv)
        DNS=$(sed -n 's/.*Property oe:key="guestinfo.dns.servers" oe:value="\([^"]*\).*/\1/p' /tmp/ovfenv)
        
        sudo yast lan delete id=0
        sudo yast lan add name=eth0 ethdevice=eth0 bootproto=static ip=$IPAddress netmask=$SubnetMask type=eth
        sudo echo "default $Gateway - eth0" > /etc/sysconfig/network/ifroute-eth0
        DNS_SERVERS=$(echo "$DNS" | sed 's/,/ /g')
        sudo sed -i "s/NETCONFIG_DNS_STATIC_SERVERS=\".*\"/NETCONFIG_DNS_STATIC_SERVERS=\"$DNS_SERVERS\"/" /etc/sysconfig/network/config
        sudo netconfig update -f
        systemctl restart wicked
runcmd:
  - bash /tmp/network-setup.sh
  - rm /tmp/network-setup.sh
  - SUSEConnect --url 192.168.13.1
```
