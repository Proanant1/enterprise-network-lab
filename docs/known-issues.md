# Known Issues and Tips (learned while building this lab)

| Problem | Cause | Fix |
|---|---|---|
| HQ-R/BR-R container exits right after start ("Graceful end (exit)!") | The GNS3 start command is the container's main process | Role scripts end with `exec /bin/sh` (already in this repo). Rebuild the image and re-create the node |
| `iptables: can't initialize iptables table 'filter'` in a node log | GNS3 VM kernel modules not loaded (containers share the VM kernel) | In the GNS3 VM run: `sudo modprobe ip_tables iptable_filter iptable_nat xt_multiport xt_state xt_conntrack xt_MASQUERADE` and add the names to `/etc/modules` |
| No VLAN sub-interfaces on routers | `8021q` module missing in the GNS3 VM | `sudo modprobe 8021q` and add to `/etc/modules` |
| OSPF neighbor never forms, log shows "Thread Starvation" and `watchfrr restart all` | GNS3 VM CPU is overloaded (2 vCPU is too few for ~10 nodes) | Give the GNS3 VM 4 vCPU. Start nodes in groups: FW and switches, then routers, then PCs |
| Node console closes and node stops | Ctrl+C was pressed in the console | Never press Ctrl+C in a node console. Close the window instead |
| "host ... not reachable" on a VPCS | PC has no IP (VPCS forgets it on restart) | `ip dhcp`, then `save` so it is requested on every start |
| First `ip dhcp` shows `DDORRRA` | Router/DHCP still starting | Wait 30 s and retry |
| VLANs broken after a restart | OVS settings are not persistent | Re-run `configs/ovs/ovs-hq.sh` / `ovs-branch.sh` in the matching OVS console only (pasting the wrong script overwrites the trunk) |
| Checked `eth1` for OSPF on HQ-R and got "not enabled" | On HQ-R, eth1 goes to the firewall; the branch link is eth2 | Use `show ip ospf interface eth2` on HQ-R and `eth1` on BR-R |

## Verified results

| Test | Result |
|---|---|
| DHCP in all VLANs (HQ and Branch) | Pass |
| HR to IT allowed, HR to Finance blocked | Pass |
| IT to Finance allowed | Pass |
| Guest isolated from internal networks (HQ and Branch) | Pass |
| Inside to DMZ web and DNS (`web.lab.local`) | Pass |
| NAT to internet | Pass |
| OSPF Full adjacency HQ-R and BR-R, default route learned | Pass |
| HQ to Branch connectivity | Pass |

## Recommended GNS3 VM sizing

4 vCPU, 4 GB RAM. Close heavy apps and watch laptop temperature (HWMonitor / Core Temp).