#!/bin/sh


mkdir -p /etc/openvpn/easy-rsa/keys /etc/openvpn/easy-rsa/templates
cp -r /usr/share/easy-rsa /etc/openvpn/
ln -s /etc/openvpn/easy-rsa/easyrsa /usr/bin

cat > etc/openvpn/easy-rsa/easyrsa.vars<<-EOF
# easy-rsa parameter settings

# NOTE: If you installed from an RPM,
# don't edit this file in place in
# /usr/share/openvpn/easy-rsa --
# instead, you should copy the whole
# easy-rsa directory to another location
# (such as /etc/openvpn) so that your
# edits will not be wiped out by a future
# OpenVPN package upgrade.

# This variable should point to
# the top level of the easy-rsa
# tree.
#export EASY_RSA="`pwd`"
export EASY_RSA="/etc/openvpn/easy-rsa"

#
# This variable should point to
# the requested executables
#
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"


# This variable should point to
# the openssl.cnf file included
# with easy-rsa.
export KEY_CONFIG=`$EASY_RSA/openssl-easyrsa.cnf $EASY_RSA`

# Edit this variable to point to
# your soon-to-be-created key
# directory.
#
# WARNING: clean-all will do
# a rm -rf on this directory
# so make sure you define
# it correctly!
export KEY_DIR="$EASY_RSA/keys"

# Issue rm -rf warning
echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR

# PKCS11 fixes
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"

# Increase this to 2048 if you
# are paranoid.  This will slow
# down TLS negotiation performance
# as well as the one-time DH parms
# generation process.
export KEY_SIZE=2048

# In how many days should the root CA key expire?
export CA_EXPIRE=3650

# In how many days should certificates expire?
export KEY_EXPIRE=365

# These are the default values for fields
# which will be placed in the certificate.
# Don't leave any of these fields blank.
export KEY_COUNTRY="DE"
export KEY_PROVINCE="BY"
export KEY_CITY="Nuremberg"
export KEY_ORG="TB"
export KEY_EMAIL="vpn@fluke667.me"
export KEY_OU="VPN"

# X509 Subject Field
export KEY_NAME="server"

# PKCS11 Smart Card
# export PKCS11_MODULE_PATH="/usr/lib/changeme.so"
# export PKCS11_PIN=1234

# If you'd like to sign all keys with the same Common Name, uncomment the KEY_CN export below
# You will also need to make sure your OpenVPN server config has the duplicate-cn option set
# export KEY_CN="CommonName"
EOF

cat > etc/openvpn/easy-rsa/templates/client-emb.conf<<EOF
client
dev tun1
proto udp
remote 1194
cipher AES-256-CBC
auth SHA512
resolv-retry infinite
redirect-gateway def1
nobind
comp-lzo yes
persist-key
persist-tun
persist-remote-ip
user openvpn
group openvpn
verb 9
script-security 2
#ca ca.crt
<ca>
</ca>

#cert client.crt
<cert>
</cert>

#key client.key
<key>
</key>

#tls-auth ta.key
<tls-auth>
</tls-auth>
EOF

cat > etc/openvpn/easy-rsa/templates/client-file.conf<<EOF
client
dev tun1
proto udp
remote 1194
cipher AES-256-CBC
auth SHA512
resolv-retry infinite
redirect-gateway def1
nobind
comp-lzo yes
persist-key
persist-tun
persist-remote-ip
user openvpn
group openvpn
verb 9
script-security 2
ca ca.crt
cert cert.crt
key key.key
tls-auth ta.key 1
EOF
