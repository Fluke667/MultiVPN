#!/bin/sh

set -e

# Sysctl Configs
sysctl -e -q -w kernel.msgmnb=65536
sysctl -e -q -w kernel.msgmax=65536
sysctl -e -q -w kernel.shmmax=68719476736
sysctl -e -q -w kernel.shmall=4294967296
sysctl -e -q -w net.ipv4.ip_forward=1
sysctl -e -q -w net.ipv4.conf.all.accept_source_route=0
sysctl -e -q -w net.ipv4.conf.all.accept_redirects=0
sysctl -e -q -w net.ipv4.conf.all.send_redirects=0
sysctl -e -q -w net.ipv4.conf.all.rp_filter=0
sysctl -e -q -w net.ipv4.conf.default.accept_source_route=0
sysctl -e -q -w net.ipv4.conf.default.accept_redirects=0
sysctl -e -q -w net.ipv4.conf.default.send_redirects=0
sysctl -e -q -w net.ipv4.conf.default.rp_filter=0
sysctl -e -q -w net.ipv4.conf.ens3.send_redirects=0
sysctl -e -q -w net.ipv4.conf.ens3.rp_filter=0

# configure firewall
iptables -t nat -A POSTROUTING -s 10.99.99.0/24 ! -d 10.99.99.0/24 -j MASQUERADE
iptables -A FORWARD -s 10.99.99.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -A FORWARD -i ppp+ -j ACCEPT
iptables -A FORWARD -o ppp+ -j ACCEPT
# MSS Clamping
iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu
# PPP
iptables -A INPUT -i ppp+ -j ACCEPT
iptables -A OUTPUT -o ppp+ -j ACCEPT
# XL2TPD
iptables -A INPUT -p tcp -m tcp --dport 1701 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 1701 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 1701 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 1701 -j ACCEPT
# IPSEC
iptables -A INPUT -p udp -m udp --dport 500 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 500 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 4500 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 4500 -j ACCEPT
iptables -A INPUT -p esp -j ACCEPT
iptables -A OUTPUT -p esp -j ACCEPT
iptables -A INPUT -p ah -j ACCEPT
iptables -A OUTPUT -p ah -j ACCEPT
# remove standard REJECT rules
echo "Note: standard REJECT rules for INPUT and FORWARD will be removed."
iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited 2>/dev/null
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited 2>/dev/null

exec "$@"
