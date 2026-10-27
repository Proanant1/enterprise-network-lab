#!/bin/sh
# DMZ web server
ip link set eth0 up
ip addr add 172.16.50.10/24 dev eth0
ip route add default via 172.16.50.1
mkdir -p /var/www/lab /run/nginx
echo "<h1>DMZ web server - Enterprise Network Lab</h1>" > /var/www/lab/index.html
cat > /etc/nginx/http.d/default.conf <<CONF
server { listen 80 default_server; root /var/www/lab; index index.html; }
CONF
nginx

# Keep the container (and its GNS3 console) alive: the start command is the main process
echo "[WEB] startup complete"
exec /bin/sh
