#!/bin/sh


pproxy -l socks4+socks5://:8090#$USER:$PASS &
sleep 2 &
pproxy -l http://:8080#$USER:$PASS &
sleep 2 &
pproxy -l ss://aes-256-gcm:yDRHHo1PjnolIVQHF3H4cpuL45udo7aHOco+Og==@:8070 &
sleep 2 &
exec /usr/sbin/openvpn --writepid /run/openvpn/ovpn.pid --cd /etc/openvpn --config /etc/openvpn/openvpn.conf 

#exec tor --RunAsDaemon 0 -f torrc.conf
