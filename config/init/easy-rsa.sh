#!/bin/sh


mkdir -p /etc/openvpn/easy-rsa/keys /etc/openvpn/easy-rsa/templates
cp -r /usr/share/easy-rsa /etc/openvpn/
ln -s /etc/openvpn/easy-rsa/easyrsa /usr/bin

cat > /etc/openvpn/easy-rsa/vars<<-EOF
set_var EASYRSA                 "/etc/openvpn/easy-rsa"
set_var EASYRSA_PKI             "/etc/openvpn/easy-rsa/pki"
set_var EASYRSA_DN              "cn_only"
set_var EASYRSA_REQ_COUNTRY     "DE"
set_var EASYRSA_REQ_PROVINCE    "BY"
set_var EASYRSA_REQ_CITY        "Nuremberg"
set_var EASYRSA_REQ_ORG         "Multivpn CERTIFICATE AUTHORITY"
set_var EASYRSA_REQ_EMAIL       "openvpn@ultivpn.io"
set_var EASYRSA_REQ_OU          "MULTIVPN EASY CA"
set_var EASYRSA_KEY_SIZE        2048
set_var EASYRSA_ALGO            rsa
set_var EASYRSA_CA_EXPIRE       7500
set_var EASYRSA_CERT_EXPIRE     365
set_var EASYRSA_NS_SUPPORT      "no"
set_var EASYRSA_NS_COMMENT      "Multivpn  CERTIFICATE AUTHORITY"
set_var EASYRSA_EXT_DIR         "/etc/openvpn/easy-rsa/x509-types"
set_var EASYRSA_SSL_CONF        "/etc/openvpn/easy-rsa/openssl-easyrsa.cnf"
set_var EASYRSA_DIGEST          "sha256"


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
