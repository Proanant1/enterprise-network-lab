# IP Plan and Wiring

## Addressing

| Site | VLAN | Name | Subnet | Gateway | DHCP pool |
|---|---|---|---|---|---|
| HQ | 10 | HR | 10.10.10.0/24 | 10.10.10.1 | .100-.200 |
| HQ | 20 | Finance | 10.10.20.0/24 | 10.10.20.1 | .100-.200 |
| HQ | 30 | IT | 10.10.30.0/24 | 10.10.30.1 | .100-.200 |
| HQ | 40 | Guest | 10.10.40.0/24 | 10.10.40.1 | .100-.200 |
| Branch | 10 | Staff | 10.20.10.0/24 | 10.20.10.1 | .100-.200 |
| Branch | 20 | Guest | 10.20.20.0/24 | 10.20.20.1 | .100-.200 |
| DMZ | - | Web | 172.16.50.0/24 | 172.16.50.1 (FW) | static |
| Transit | - | HQ-R to FW | 10.255.0.0/30 | .1 HQ-R, .2 FW | static |
| Transit | - | HQ-R to BR-R | 10.255.1.0/30 | .1 HQ-R, .2 BR-R | static |
| Outside | - | FW to NAT | 192.168.122.0/24 | DHCP | DHCP |

Static fallback for VPCS (if you skip DHCP): `ip 10.10.10.10/24 10.10.10.1`, `ip 10.10.20.10/24 10.10.20.1`, etc.

## Wiring (GNS3 adapter to adapter)

| From | To |
|---|---|
| HQ-R eth0 | OVS-HQ eth0 (trunk) |
| HQ-R eth1 | FW eth0 |
| HQ-R eth2 | BR-R eth1 |
| OVS-HQ eth1 / eth2 / eth3 / eth4 | HR-PC / FIN-PC / IT-PC / GUEST-PC |
| FW eth1 | DMZ-WEB eth0 |
| FW eth2 | GNS3 NAT cloud |
| BR-R eth0 | OVS-BR eth0 (trunk) |
| OVS-BR eth1 / eth2 | BR-STAFF-PC / BR-GUEST-PC |

## Policy summary

| Source | Allowed | Blocked |
|---|---|---|
| HR | Everything except Finance | Finance |
| Finance | Everything except HR | HR |
| IT | Everything | - |
| Guest (HQ and Branch) | Internet, DMZ web (80/443) | All internal networks |
| DMZ | Replies only | Initiating to inside or internet |
