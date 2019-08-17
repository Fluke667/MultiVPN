#!/bin/sh

echo "${INFO} ***** PREPARE DIRECTORYS AND FILES *****"
if [ ! -d "/var/run/sshd" ]; then
mkdir -p /var/run/sshd
fi
if [ ! -d "/etc/ssh/keys" ]; then
mkdir -p /etc/ssh/keys
fi
if [ ! -d "/etc/ssh/keys/authorized_keys" ]; then
mkdir -p /etc/ssh/keys/authorized_keys
fi
if [ ! -d "/etc/openvpn/easy-rsa/keys" ]; then
mkdir -p /etc/openvpn/easy-rsa/keys 
fi
if [ ! -d "/etc/openvpn/easy-rsa/templates" ]; then
mkdir -p /etc/openvpn/easy-rsa/templates 
fi
if [ ! -d "/etc/openvpn/server" ]; then
mkdir -p /etc/openvpn/server
fi
if [ ! -d "/etc/openvpn/client" ]; then
mkdir -p /etc/openvpn/client
fi
if [ ! -d "/var/log/openvpn" ]; then
mkdir -p /var/log/openvpn 
fi
if [ ! -d "/run/openvpn" ]; then
mkdir -p /run/openvpn
fi
if [ ! -d "/dev/net" ]; then
mkdir -p /dev/net
fi
if [ ! -d "/etc/tinc" ]; then
mkdir -p /etc/tinc 
fi
if [ ! -d "/etc/tinc/$TINC_NETNAME" ]; then
mkdir -p /etc/tinc/$TINC_NETNAME 
fi
if [ ! -d "/etc/tinc/$TINC_NETNAME/hosts" ]; then
mkdir -p /etc/tinc/$TINC_NETNAME/hosts 
fi
if [ ! -d "/var/log/tinc" ]; then
mkdir -p /var/log/tinc
fi
if [ ! -d "/etc/peervpn" ]; then
mkdir -p /etc/peervpn
fi
if [ ! -d "/etc/cloak" ]; then
mkdir -p /etc/cloak
fi
if [ ! -d "/run/stunnel" ]; then
mkdir -p /run/stunnel
fi
if [ ! -d "/var/log/stunnel" ]; then
mkdir -p /var/log/stunnel
fi

mkdir -p 
mkdir -p 
mkdir -p 
mkdir -p 
mkdir -p 
mkdir -p 
mkdir -p 

if [ -e /etc/ipsec.d/ipsec.conf ]
then
    echo "Initialized!"
    exit 0
else
    echo "Initializing..."
fi



rngd -r /dev/urandom
touch /etc/peervpn/peervpn.conf
addgroup -g 19001 -S $TOR_USER && adduser -u 19001 -G $TOR_USER -S $TOR_USER
chown -Rv ${TOR_USER}:${TOR_USER} /var/lib/tor  
chmod -R 700 /var/lib/tor
chmod 0600 /etc/peervpn/peervpn.conf

"$@"
