# Paste in the OVS-BR console
ovs-vsctl set port eth0 vlan_mode=trunk trunks=10,20
ovs-vsctl set port eth1 tag=10   # Branch staff
ovs-vsctl set port eth2 tag=20   # Branch guest
ovs-vsctl show
