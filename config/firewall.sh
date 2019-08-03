#!/bin/sh

set -e

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
