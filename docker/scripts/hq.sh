#!/bin/sh
# HQ router: router-on-a-stick, DHCP/DNS, OSPF, inter-VLAN firewall policy
for i in eth0 eth1 eth2; do ip link set $i up; done

# VLAN sub-interfaces on the trunk (eth0 -> OVS-HQ)
for v in 10 20 30 40; do
  ip link add link eth0 name eth0.$v type vlan id $v
  ip addr add 10.10.$v.1/24 dev eth0.$v
  ip link set eth0.$v up
done

ip addr add 10.255.0.1/30 dev eth1   # to VyOS firewall
ip addr add 10.255.1.1/30 dev eth2   # to Branch router
sysctl -w net.ipv4.ip_forward=1 >/dev/null

# ---- Policy (ACL equivalent) ----
iptables -F FORWARD
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# Guest: only web in DMZ + internet, nothing internal
iptables -A FORWARD -s 10.10.40.0/24 -d 172.16.50.0/24 -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -s 10.10.40.0/24 -d 10.0.0.0/8 -j DROP
iptables -A FORWARD -s 10.10.40.0/24 -d 172.16.0.0/12 -j DROP
# Branch guest must not reach HQ internal networks
iptables -A FORWARD -s 10.20.20.0/24 -d 10.10.0.0/16 -j DROP
# HR <-> Finance separation
iptables -A FORWARD -s 10.10.10.0/24 -d 10.10.20.0/24 -j DROP
iptables -A FORWARD -s 10.10.20.0/24 -d 10.10.10.0/24 -j DROP
iptables -P FORWARD ACCEPT

# FRR (OSPF) + DHCP/DNS
cp /opt/lab/frr-hq/* /etc/frr/
chown frr:frr /etc/frr/* 2>/dev/null
/usr/lib/frr/frrinit.sh start
dnsmasq -C /opt/lab/dnsmasq/hq.conf

# Keep the container (and its GNS3 console) alive: the start command is the main process
echo "[HQ] startup complete"
exec /bin/sh
