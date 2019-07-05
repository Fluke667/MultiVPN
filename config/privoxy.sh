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

	sed -i'' 's/127\.0\.0\.1:8118/0\.0\.0\.0:8118/' /etc/privoxy/privoxy.conf && \
    echo 'forward-socks5  /       127.0.0.1:1080  .' >> /etc/privoxy/privoxy.conf
