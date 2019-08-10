#!/bin/sh


mkdir -p /etc/openvpn/easy-rsa/keys /etc/openvpn/easy-rsa/templates
cp -r /usr/share/easy-rsa /etc/openvpn/
ln -s /etc/openvpn/easy-rsa/easyrsa /usr/bin

cat > /etc/openvpn/easy-rsa/easyrsa.vars<<-EOF
export EASY_RSA="/etc/openvpn/easy-rsa"
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/openssl-easyrsa.cnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=365
export KEY_COUNTRY="DE"
export KEY_PROVINCE="BY"
export KEY_CITY="Nuremberg"
export KEY_ORG="TB"
export KEY_EMAIL="vpn@fluke667.me"
export KEY_OU="VPN"
export KEY_NAME="server"

# PKCS11 Smart Card
# export PKCS11_MODULE_PATH="/usr/lib/changeme.so"
# export PKCS11_PIN=1234

# If you'd like to sign all keys with the same Common Name, uncomment the KEY_CN export below
# You will also need to make sure your OpenVPN server config has the duplicate-cn option set
# export KEY_CN="CommonName"
EOF

cat > /etc/openvpn/easy-rsa/templates/client-emb.conf<<EOF
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

cat > /etc/openvpn/easy-rsa/templates/client-file.conf<<EOF
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
