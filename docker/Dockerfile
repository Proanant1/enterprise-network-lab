# One lightweight image used for 3 roles: HQ router, Branch router, DMZ web server.
# Role is chosen by the "Start command" in the GNS3 template (see docs/setup-guide.md).
FROM frrouting/frr:v9.1.0

RUN apk add --no-cache iproute2 iptables dnsmasq nginx bash tcpdump busybox-extras

COPY docker/scripts/ /opt/lab/
COPY configs/frr-hq/ /opt/lab/frr-hq/
COPY configs/frr-branch/ /opt/lab/frr-branch/
COPY configs/dnsmasq/ /opt/lab/dnsmasq/
RUN chmod +x /opt/lab/*.sh

ENTRYPOINT []
CMD ["/bin/sh"]
