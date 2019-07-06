#!/bin/sh


cat > /etc/openvpn/server.conf <<EOF
mode server
port 1194
proto udp
dev tun
crl-verify OPENVPNDIR/crl.pem
ca CADIR/keys/ca.crt
cert CADIR/keys/openvpn-server.crt
key CADIR/keys/openvpn-server.key
dh CADIR/keys/dh2048.pem
tls-server
tls-auth CADIR/ta.key 0
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
`cat key.pem`
</key>
<cert>
`cat cert.pem`
</cert>
<ca>
`cat cert.pem`
</ca>
<dh>
`cat dh.pem`
</dh>
<connection>
remote $MY_IP_ADDR 1194 udp
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
