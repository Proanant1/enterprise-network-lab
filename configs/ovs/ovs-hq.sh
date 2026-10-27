# Paste in the OVS-HQ console (GNS3 Open vSwitch appliance)
ovs-vsctl set port eth0 vlan_mode=trunk trunks=10,20,30,40
ovs-vsctl set port eth1 tag=10   # HR
ovs-vsctl set port eth2 tag=20   # Finance
ovs-vsctl set port eth3 tag=30   # IT
ovs-vsctl set port eth4 tag=40   # Guest
ovs-vsctl show
