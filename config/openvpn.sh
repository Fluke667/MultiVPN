#!/bin/sh

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

if [ ! -f "$OVPN_TLSAUTH_KEY" ]
then

  echo " ---> Generate Openvpn TLS-Auth Key"
  openvpn \
    --genkey --secret "$OVPN_TLSAUTH_KEY"
    
else
  echo "ENTRYPOINT: tlsauth.key already exists"       
fi
    
    

IP=$(grep '^server .*$' /etc/openvpn/server.conf | awk '{print $2}')


/usr/sbin/openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2
