# Troubleshooting Labs

Do the break step, observe the symptom, diagnose, fix, and write it up in your report
(symptom, commands used, root cause, fix, prevention).

| # | Break it | Symptom | Diagnose | Fix |
|---|---|---|---|---|
| 1 | OVS-HQ: `ovs-vsctl set port eth1 tag=20` | HR PC gets Finance IP or no DHCP | `ovs-vsctl show`, `ip dhcp` output | Set `tag=10` |
| 2 | OVS-HQ: remove VLAN 30 from trunk: `ovs-vsctl set port eth0 trunks=10,20,40` | IT PC has no gateway or DHCP | Check trunk list, `tcpdump -i eth0` on HQ-R | Re-add 30 to trunks |
| 3 | HQ-R: `ip link del eth0.20` | Finance VLAN dead | `ip -br addr`, ping gateway | Recreate sub-interface and IP |
| 4 | BR-R: change `ospf router-id` to 1.1.1.1 | OSPF neighbor flaps/not forming | `vtysh -c "show ip ospf neighbor"` | Unique router-id, restart ospfd |
| 5 | BR-R: remove `network 10.255.1.0/30 area 0` | Branch isolated from HQ | `show ip ospf interface`, `show ip route` | Add the network back |
| 6 | HQ-R: delete the HR-to-Finance DROP rule | HR can reach Finance (security hole) | `iptables -L FORWARD -n -v` | Re-add rule |
| 7 | HQ-R: put guest DROP above the web ACCEPT | Guest cannot reach DMZ web | Check rule order and hit counters | Reorder (ACCEPT first) |
| 8 | VyOS: delete `nat source rule 100` | Internet fails, internal OK | `show nat source rules`, `ping 8.8.8.8` from FW vs from PC | Re-add NAT rule |
| 9 | VyOS: delete route to 10.20.0.0/16 | Branch can reach internet one way only (no return) | `traceroute`, `show ip route` on FW | Re-add static route |
| 10 | Give two PCs the same static IP | Intermittent connectivity | `arp` output, duplicate MAC for one IP | Fix addressing, use DHCP |

## Useful commands

| Device | Commands |
|---|---|
| FRR routers | `vtysh -c "show ip route"`, `show ip ospf neighbor`, `iptables -L FORWARD -n -v`, `ip -br addr`, `tcpdump -i eth0 -n` |
| OVS | `ovs-vsctl show`, `ovs-appctl fdb/show br0` |
| VyOS | `show interfaces`, `show ip route`, `show nat source translations`, `show firewall` |
| VPCS | `show ip`, `ping`, `trace`, `arp` |
| Any link | Right-click link in GNS3, Start capture (Wireshark) |
