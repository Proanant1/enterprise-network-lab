# Setup Guide

## 1. Install
- VirtualBox, GNS3 (GUI) and the **GNS3 VM** (VirtualBox .ova), all the **same version** (tested with 2.2.61). Free.
- Keep the GNS3 VM at 2 vCPU / 4 GB RAM to reduce heat.
- In the GNS3 Setup Wizard choose "Run appliances in a virtual machine", **VirtualBox**, VM name "GNS3 VM".

## 2. Build the Docker images inside the GNS3 VM
The pasting into the VM console may not work, so SSH in from Windows (password `gns3`; if the blue menu appears choose Shell):

```bash
ssh gns3@<GNS3-VM-IP>        # IP shown in the VM "Information" menu, usually 192.168.56.101
git clone https://github.com/Proanant1/enterprise-network-lab.git
cd enterprise-network-lab
sudo docker build -f docker/Dockerfile -t ent-lab/node .
sudo docker pull gns3/openvswitch:latest
```
To update later: `cd enterprise-network-lab && git pull` and rebuild.

## 3. Create GNS3 templates
**Docker templates** (Edit > Preferences > Docker > Docker containers > New).
Run on the GNS3 VM, console type telnet, then click **Apply** and **OK**.

| Template | Image | Adapters | Start command |
|---|---|---|---|
| HQ-R | ent-lab/node:latest | 3 | `sh /opt/lab/hq.sh` |
| BR-R | ent-lab/node:latest | 2 | `sh /opt/lab/branch.sh` |
| FW | ent-lab/node:latest | 3 | `sh /opt/lab/fw.sh` |
| DMZ-WEB | ent-lab/node:latest | 1 | `sh /opt/lab/web.sh` |
| OVS | gns3/openvswitch:latest | 8 | (empty) |

Built-in: **VPCS** and **NAT** (no setup needed).

## 4. Wire and configure
1. Wire using `docs/ip-plan-and-wiring.md`.
2. Start everything.
3. OVS-HQ console: paste `configs/ovs/ovs-hq.sh`. OVS-BR console: paste `configs/ovs/ovs-branch.sh`.
4. On each VPCS: `ip dhcp`.

If OVS settings vanish after a restart, re-run the scripts.
(Optional: `configs/optional/vyos-fw.vyos` is a VyOS version of the firewall if you prefer a real router OS and have the RAM.)

## 5. Verify
Run `docs/test-plan.md`.
