#!/bin/sh

#if [ ! -f $OVPN_CA_CRT ]
if [ ! -f "/etc/openvpn/ca/ca.crt" ]
then
chmod 0777 /etc/openvpn/vpnconf
cd /etc/openvpn && ./vpnconf server --server
cd /etc/openvpn && ./vpnconf client --client
else
echo "Openvpn Certificates already exists"
fi
