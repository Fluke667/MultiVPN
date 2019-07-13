#!/bin/sh

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

IP=$(grep '^server .*$' /etc/openvpn/server.conf | awk '{print $2}')



/usr/sbin/openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2
