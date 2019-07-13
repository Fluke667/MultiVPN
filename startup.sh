#!/bin/sh

chmod 0777 /etc/openvpn/vpnconf
cd /etc/openvpn && ./vpnconf server --server
cd /etc/openvpn && ./vpnconf client --client
