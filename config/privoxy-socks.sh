#!/bin/sh

cat > /etc/shadowsocks-libev/privoxy-socks.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":8118,
    "local_port":1080,
    "password":"MyPass",
    "timeout":180,
    "method":"aes-256-gcm"
}
EOF
