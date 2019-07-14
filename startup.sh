#!/bin/sh



#if [ ! -f "/etc/openvpn/ca/ca.crt" ]



if [ ! -f "$OVPN_CA_CRT" ]
then
echo "Openvpn Certificates already exists"
else
chmod 0777 /etc/openvpn/vpnconf
cd /etc/openvpn && ./vpnconf server --server
cd /etc/openvpn && ./vpnconf client --client
fi
