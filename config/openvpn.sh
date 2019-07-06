#!/bin/sh


cat > /etc/openvpn/server.conf <<EOF
server 192.168.255.128 255.255.255.128
verb 3
duplicate-cn
key key.pem
ca cert.pem
cert cert.pem
dh dh.pem
keepalive 10 60
persist-key
persist-tun
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
comp-lzo
client-to-client
proto udp
port 1194
dev tun
status openvpn-status.log
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
