#!/bin/sh

cd /usr/share/easy-rsa
./easyrsa init-pki
./easyrsa gen-dh
cd /usr/share/easy-rsa/pki
cp dh.pem /etc/openvpn
#
cd /usr/share/easy-rsa

./easyrsa build-ca nopass << EOF
EOF
# CA creation complete and you may now import and sign cert requests.
# Your new CA certificate file for publishing is at:
# /usr/share/easy-rsa/pki/ca.crt

./easyrsa gen-req MyReq nopass << EOF2
EOF2
# Keypair and certificate request completed. Your files are:
# req: /usr/share/easy-rsa/pki/reqs/MyReq.req
# key: /usr/share/easy-rsa/pki/private/MyReq.key

./easyrsa sign-req server MyReq << EOF3
yes
EOF3
# Certificate created at: /usr/share/easy-rsa/pki/issued/MyReq.crt

#Copy server keys and certificates
cd /usr/share/easy-rsa/pki
cp ca.crt issued/MyReq.crt private/MyReq.key /etc/openvpn


cat > /etc/openvpn/server.conf <<EOF
mode server
port 1194
proto udp
dev tun
crl-verify OVPN_DIR/crl.pem
ca CRT_CERT_DIR/keys/ca.crt
cert CRT_CERT_DIRopenvpn-server.crt
key CRT_CERT_DIR/openvpn-server.key
dh CRT_CERT_DIR/dh2048.pem
tls-server
tls-auth CRT_CERT_DIR/ta.key 0
server LOCALPREFIX.0.0 255.255.255.0
topology subnet
local PUBLICIP
client-to-client
cipher AES-256-CBC
user nobody
group NOBODYGROUP
max-clients 100
keepalive 10 120
persist-key
persist-tun
mssfix
push "route-gateway dhcp"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
EOF

cat > /etc/openvpn/client-emb.ovpn <<EOF
client
nobind
dev tun
#redirect-gateway def1
comp-lzo
resolv-retry infinite
<key>
`cat CRT_CERT_DIR/openvpn-server.key
</key>
<cert>
`cat CRT_CERT_DIR/ca-cert.pem
</cert>
<ca>
`cat CRT_CERT_DIR/ca-cert.pem
</ca>
<dh>
`cat CRT_CERT_DIR/dh2048.pem
</dh>
<connection>
remote $IP_ADDR 1194 udp
</connection>
EOF

cat > /etc/openvpn/client-file.ovpn <<EOF
client
dev tun
persist-key
persist-tun
cipher AES-256-CBC
remote IP
port 1194
proto udp
resolv-retry infinite
redirect-gateway def1
tls-client
remote-cert-tls server
tls-auth ta.key 1
ca ca.crt
cert LOGIN.crt
key LOGIN.key 
EOF
