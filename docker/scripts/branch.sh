#!/bin/sh
# Branch router: router-on-a-stick, DHCP/DNS, OSPF to HQ
for i in eth0 eth1; do ip link set $i up; done
for v in 10 20; do
  ip link add link eth0 name eth0.$v type vlan id $v
  ip addr add 10.20.$v.1/24 dev eth0.$v
  ip link set eth0.$v up
done
ip addr add 10.255.1.2/30 dev eth1
sysctl -w net.ipv4.ip_forward=1 >/dev/null

iptables -F FORWARD
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.20.20.0/24 -d 172.16.50.0/24 -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -s 10.20.20.0/24 -d 10.0.0.0/8 -j DROP
iptables -A FORWARD -s 10.20.20.0/24 -d 172.16.0.0/12 -j DROP
iptables -P FORWARD ACCEPT

cp /opt/lab/frr-branch/* /etc/frr/
chown frr:frr /etc/frr/* 2>/dev/null
/usr/lib/frr/frrinit.sh start
dnsmasq -C /opt/lab/dnsmasq/branch.conf

# Keep the container (and its GNS3 console) alive: the start command is the main process
echo "[BRANCH] startup complete"
exec /bin/sh
