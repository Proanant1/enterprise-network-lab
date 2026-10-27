# Test Plan

| # | Test (from) | Command | Expected |
|---|---|---|---|
| 1 | DHCP (any PC) | `ip dhcp` | Gets address in own subnet |
| 2 | Gateway (HR) | `ping 10.10.10.1` | Success |
| 3 | HR to IT | `ping 10.10.30.10` (use real IP) | Success |
| 4 | HR to Finance | ping Finance PC | **Fail** (policy) |
| 5 | Guest to IT | ping IT PC | **Fail** |
| 6 | Guest to DMZ web | `ping 172.16.50.10` | Fail (ICMP blocked for guest) |
| 7 | Any HQ PC to Branch | ping Branch staff PC | Success (OSPF) |
| 8 | Branch guest to HQ | ping HQ PC | **Fail** |
| 9 | Internet via NAT | `ping 8.8.8.8` (from HR) | Success |
| 10 | DNS | `ping web.lab.local` | Resolves to 172.16.50.10 |
| 11 | OSPF (HQ-R) | `vtysh -c "show ip ospf neighbor"` | BR-R in Full state |
| 12 | Routes (BR-R) | `vtysh -c "show ip route"` | 10.10.x.0/24 and 0.0.0.0/0 via OSPF |
| 13 | DMZ isolation | From DMZ-WEB: `ping 10.10.30.10` | **Fail** |
| 14 | NAT counters (FW) | `iptables -t nat -L -n -v` | MASQUERADE counters increase after test 9 |

Note: VPCS ping tests use ICMP. TCP 80/443 to the DMZ web can be tested from an IT-VLAN
Docker/Linux client or with `wget` from a container.
