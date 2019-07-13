#!/bin/sh

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

IP=$(grep '^server .*$' /etc/openvpn/server.conf | awk '{print $2}')

#Generate Config Files
/etc/openvpn/vpnconf server --server
/etc/openvpn/vpnconf client --client

/usr/sbin/openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2
