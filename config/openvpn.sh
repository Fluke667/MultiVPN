#!/bin/sh

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

IP=$(grep '^server .*$' /etc/openvpn/server.conf | awk '{print $2}')

# first initialize easyrsa root keys and certificates:
easyrsa init-pki
easyrsa build-ca nopass
easyrsa gen-req server nopass
#easyrsa gen-req $1
easyrsa sign-req server server
openssl verify -CAfile pki/ca.crt pki/issued/server.crt
easyrsa gen-req vpn01de nopass

/usr/sbin/openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2
