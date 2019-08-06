#!/bin/sh

rm /etc/pptpd.conf
rm /etc/ppp/pptpd-options

cat > /etc/pptpd.conf <<-EOF
option /etc/ppp/pptpd-options
#debug
#stimeout 10
logwtmp
#bcrelay eth1
#delegate
#connections 100
#speed 115200
localip 192.168.0.1
remoteip 192.168.1.100-199
#ipxnets 00001000-00001FFF
#listen 192.168.0.1
pidfile /var/run/pptpd.pid
EOF

cat > /etc/ppp/pptpd-options <<EOF
name pptpd
refuse-mschap
refuse-pap
refuse-chap
require-mschap-v2
require-mppe-128

# Network and Routing
ms-dns 1.1.1.1
ms-dns 1.0.0.1
proxyarp
nodefaultroute

# Logging
# debug
# dump

# Miscellaneous
lock
nobsdcomp
novj
novjccomp
nologfd
EOF


cat > /etc/ppp/chap-secrets <<EOF
# Secrets for authentication using CHAP
# client        server  secret            acceptable local IP addresses
MyUser          pptpd  MyPass
EOF

"$@"
