#!/bin/sh

cat > /etc/shadowsocks-libev/privoxy.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":8118,
    "local_port":1080,
    "password":"MyPass",
    "timeout":180,
    "method":"aes-256-gcm"
}
EOF

sed -i '/^listen-address.*/d' /etc/privoxy/config      
echo "listen-address  ${PRV_SERVER}:${PRV_SERVER_PORT}" >> /etc/privoxy/config       
echo "forward-socks5   /               ${PRV_LOCAL}:${PRV_LOCAL_PORT} ." >> /etc/privoxy/config
chown privoxy.privoxy /etc/privoxy/*
