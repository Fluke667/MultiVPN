#!/bin/sh

pproxy -l socks4+socks5://:8090#$PPROXY_USER:$PPROXY_PASS &
pproxy -l http://:8080#$PPROXY_USER:$PPROXY_PASS &
pproxy -l ss://aes-256-gcm:yDRHHo1PjnolIVQHF3H4cpuL45udo7aHOco+Og==@:8070 &
openvpn --writepid /run/openvpn/ovpn.pid --cd /etc/openvpn --config /etc/openvpn/openvpn.conf &
proxybroker serve --host 0.0.0.0 --port 8888 --types HTTP HTTPS --lvl High &
tinc --net=$TINC_NETNAME start -D --config=$TINC_DIR/$TINC_NETNAME -D --debug=$TINC_DEBUG --logfile=$TINC_LOG &
ss-server -c /etc/shadowsocks-libev/standalone.json


$@
