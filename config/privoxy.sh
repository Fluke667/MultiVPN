#!/bin/sh

cat > /etc/shadowsocks-libev/privoxy.json <<EOF
{
    "server":"${PRV_SERVER:-0.0.0.0}",
    "server_port":${PRV_SERVER_PORT:-8118},
    "password":"${PRV_PASS:-MyPass}",
    "method":"${PRV_METHOD:-aes-256-gcm}"
    "local_port":${PRV_LOCAL:-127.0.0.1},
    "local_port":${PRV_LOCAL_PORT:-1080},
    "timeout":${PRV_TIMEOUT:-60},
}
EOF




#echo "actionsfile gfwlist.action" >> /etc/privoxy/config && \
#sed -i 's/enable-edit-actions 0/enable-edit-actions 1/g' /etc/privoxy/config && \
#sed -i 's/listen-address  127.0.0.1:8118/listen-address  0.0.0.0:8118/g' /etc/privoxy/config



sed -i '/^listen-address.*/d' /etc/privoxy/config
echo "listen-address  ${PRV_SERVER}:${PRV_SERVER_PORT}" >> /etc/privoxy/config
echo "forward-socks5   /               ${PRV_LOCAL}:${PRV_LOCAL_PORT} ." >> /etc/privoxy/config
chown privoxy.privoxy /etc/privoxy/*


privoxy --user privoxy /etc/privoxy/config &
#ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/privoxy.json
ss-local -s $PRV_SERVER -p $PRV_SERVER_PORT -k $PRV_PASS -m $PRV_METHOD -b $PRV_LOCAL -l $PRV_LOCAL_PORT -t $PRV_TIMEOUT --fast-open -u
$@










