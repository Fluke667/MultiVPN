#!/bin/sh

set -e

rngd -r /dev/urandom

cat > /etc/shadowsocks-libev/shadowsocks.json <<EOF
{
    "server":"${SS_SERVER_ADDR:-0.0.0.0}",
    "server_port":${SS_SERVER_PORT:-8388},
    "password":"${SS_PASSWORD:-MyPass}",
    "method":"${SS_METHOD:-aes-256-gcm}",
    "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
    "local_port":${SS_LOCAL_PORT:-1080},
    "timeout":${SS_TIMEOUT:-60},
    "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
    "mode":"${SS_MODE:-tcp_and_udp}",
    "fast_open": true,
    "reuse_port": true
}
EOF

exec ss-server -c /etc/shadowsocks-libev/shadowsocks.json
#exec ss-server -v -s ${SS_SERVER_ADDR} -p ${SS_SERVER_PORT} -l ${SS_LOCAL_PORT} -k ${SS_PASSWORD} -t ${SS_TIMEOUT} -m ${SS_METHOD} -n ${SS_MAXOPENFILES} -d ${SS_DNS} --fast-open --reuse-port -u 
$@
