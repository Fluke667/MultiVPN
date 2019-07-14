#!/bin/sh

if [ ! -f "$OVPN_CA_CRT" ]
then

chmod 0777 /etc/openvpn/vpnconf
cd /etc/openvpn && ./vpnconf server --server
cd /etc/openvpn && ./vpnconf client --client

else
  echo "Openvpn Certificates already exists"
fi
