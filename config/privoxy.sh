#!/bin/sh

cat > /etc/shadowsocks-libev/privoxy.json <<EOF
{
    "server":"${PRV_SERVER:-0.0.0.0}",
    "server_port":${PRV_SERVER_PORT:-8118},
    "local_port":${PRV_LOCAL_PORT:-1080},
    "password":"${PRV_PASS:-MyPass}",
    "timeout":${PRV_TIMEOUT:-60},
    "method":"${PRV_METHOD:-aes-256-gcm}"
}
EOF

sed -i '/^listen-address.*/d' /etc/privoxy/config      
echo "listen-address  ${PRV_SERVER}:${PRV_SERVER_PORT}" >> /etc/privoxy/config       
echo "forward-socks5   /               ${PRV_LOCAL}:${PRV_LOCAL_PORT} ." >> /etc/privoxy/config
chown privoxy.privoxy /etc/privoxy/*
