# Setup Guide

## 1. Install
- GNS3 (GUI) and the **GNS3 VM** (VirtualBox or VMware Player). Free.
- Keep the GNS3 VM at 2 vCPU / 4 GB RAM to reduce heat.

## 2. Build the Docker image inside the GNS3 VM
The GNS3 VM has Docker. Copy this repo into it and build:

```bash
scp -r enterprise-network-lab gns3@<GNS3-VM-IP>:~     # default password: gns3
ssh gns3@<GNS3-VM-IP>
cd enterprise-network-lab
docker build -f docker/Dockerfile -t ent-lab/node .
```

## 3. Create GNS3 templates
**Docker templates** (Edit > Preferences > Docker containers > New), image `ent-lab/node`:

| Template | Adapters | Start command |
|---|---|---|
| HQ-R | 3 | `sh /opt/lab/hq.sh` |
| BR-R | 2 | `sh /opt/lab/branch.sh` |
| DMZ-WEB | 1 | `sh /opt/lab/web.sh` |

Console type: telnet. Tick "privileged" if offered.

**Other devices**
- Open vSwitch: import from the GNS3 marketplace/appliance list (8 adapters). Needed twice.
- VPCS: built in.
- VyOS: download the free rolling or 1.4 ISO, import the VyOS appliance in GNS3, 3 adapters, install with `install image`.
- NAT: built in "NAT" cloud node.

## 4. Wire and configure
1. Wire using `docs/ip-plan-and-wiring.md`.
2. Start everything.
3. OVS-HQ console: paste `configs/ovs/ovs-hq.sh`. OVS-BR console: paste `configs/ovs/ovs-branch.sh`.
4. VyOS console: `configure`, paste `configs/vyos/fw.vyos`, then `commit` and `save`.
5. On each VPCS: `ip dhcp`.

If OVS settings vanish after a restart, re-run the scripts.

## 5. Verify
Run `docs/test-plan.md`.
