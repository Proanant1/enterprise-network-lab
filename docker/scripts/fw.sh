#!/bin/sh
# Firewall / NAT / DMZ gateway (Docker role, replaces VyOS to save RAM and heat)
# eth0 = inside (to HQ-R), eth1 = DMZ, eth2 = outside (GNS3 NAT cloud)
for i in eth0 eth1 eth2; do ip link set $i up; done
ip addr add 10.255.0.2/30 dev eth0
ip addr add 172.16.50.1/24 dev eth1

# Outside: DHCP from the GNS3 NAT node (also installs the default route)
udhcpc -i eth2 -b -q

# Return routes to internal networks
ip route add 10.10.0.0/16 via 10.255.0.1
ip route add 10.20.0.0/16 via 10.255.0.1
sysctl -w net.ipv4.ip_forward=1 >/dev/null

# ---- Firewall policy: default deny ----
iptables -F
iptables -t nat -F
iptables -P FORWARD DROP
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp -m multiport --dports 80,443 -j ACCEPT   # inside -> DMZ web
iptables -A FORWARD -i eth0 -o eth1 -p icmp -j ACCEPT                                # inside -> DMZ ping
iptables -A FORWARD -i eth0 -o eth2 -j ACCEPT                                        # inside -> internet
# DMZ -> inside and DMZ -> internet are dropped by the default policy

# NAT internal networks out to the internet
iptables -t nat -A POSTROUTING -o eth2 -s 10.0.0.0/8 -j MASQUERADE

# Keep the container (and its GNS3 console) alive: the start command is the main process
echo "[FW] startup complete"
exec /bin/sh
