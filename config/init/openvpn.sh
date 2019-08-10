#!/bin/sh

mkdir -p /etc/openvpn/easy-rsa/keys /etc/openvpn/easy-rsa/templates /etc/openvpn/server /etc/openvpn/client
cp -r /usr/share/easy-rsa /etc/openvpn/

mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 0666 /dev/net/tun

if [ ! -f $OVPN_TLSAUTH.key ]
then
  echo " ---> Generate Openvpn TLS-Auth Key"
  openvpn \
    --genkey --secret $OVPN_TLSAUTH.key
else
  echo "ENTRYPOINT: $OVPN_TLSAUTH.key already exists"       
fi

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


cd /etc/openvpn/easy-rsa/ &
# Initialization
./easyrsa init-pki &
# Build CA
./easyrsa build-ca nopass &
# Build Diffie Hellmann
./easyrsa gen-dh &
# Build Server Key
./easyrsa gen-req $OVPN_SRV_NAME nopass &
./easyrsa sign-req server $OVPN_SRV_NAME &
# Build Client Key
./easyrsa gen-req $OVPN_CLI_NAME nopass &
./easyrsa sign-req client $OVPN_CLI_NAME &
# Build Diffie Hellmann
./easyrsa gen-dh &
# Copy all the Files
cp pki/ca.crt /etc/openvpn/server/ &
cp pki/issued/$OVPN_SRV_NAME.crt /etc/openvpn/server/ &
cp pki/private/$OVPN_SRV_NAME.key /etc/openvpn/server/ &
cp pki/dh.pem /etc/openvpn/server/ &
cp pki/crl.pem /etc/openvpn/server/ &
cp pki/ca.crt /etc/openvpn/client/ &
cp pki/issued/$OVPN_CLI_NAME.crt /etc/openvpn/client/ &
cp pki/private/$OVPN_CLI_NAME.key /etc/openvpn/client/ &


echo " ---> Generate Openvpn file ${OVPN_CLI_NAME}-emb.ovpn"
    echo client > ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo dev tun1 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo proto udp >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo remote ${IP_ADDR} 1194 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo cipher AES-256-CBC >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo auth SHA512 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo resolv-retry infinite >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo redirect-gateway def1 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo nobind >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo comp-lzo yes >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo persist-key >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo persist-tun >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo persist-remote-ip >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo verb 9 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo script-security 2 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo ns-cert-type server >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    #echo setenv ALLOW_PASSWORD_SAVE 0 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn 
    #echo auth-user-pass >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '<ca>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    cat ${OVPN_CLI_CA} >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '</ca>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '<cert>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    cat ${OVPN_CLI_CRT}/${OVPN_CLI_NAME}.crt >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '</cert>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '<key>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    cat ${OVPN_CLI_CRT}/${OVPN_CLI_NAME}.key >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '</key>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '<tls-auth>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    cat ${OVPN_TLSAUTH}.key >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
    echo '</tls-auth>' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-emb.ovpn
echo " ---> Generate Openvpn file ${OVPN_CLI_NAME}-file.ovpn"
    echo client > ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo dev tun1 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo proto udp >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo remote ${IP_ADDR} 1194 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo cipher AES-256-CBC >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo auth SHA512 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo resolv-retry infinite >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo redirect-gateway def1 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo nobind >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo comp-lzo yes >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo persist-key >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo persist-tun >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo persist-remote-ip >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo verb 9 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo script-security 2 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo ns-cert-type server >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    #echo setenv ALLOW_PASSWORD_SAVE 0 >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn 
    #echo auth-user-pass >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo 'ca ca.crt' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo 'cert ${OVPN_CLI_NAME}.crt' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo 'key ${OVPN_CLI_NAME}.key' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
    echo 'tls-auth ta.key 1' >> ${OVPN_CCD_DIR}/${OVPN_CLI_NAME}-file.ovpn
echo " ---> Generate openvpn.conf Config file "
    echo port 1194 > ${OVPN_CONFIG}.conf
    echo proto udp >> ${OVPN_CONFIG}.conf
    echo dev tun1 >> ${OVPN_CONFIG}.conf
    echo ca ${OVPN_SRV_CA} >> ${OVPN_CONFIG}.conf
    echo cert ${OVPN_SRV_CRT}/${OVPN_SRV_NAME}.crt >> ${OVPN_CONFIG}.conf
    echo key ${OVPN_SRV_CRT}/${OVPN_SRV_NAME}.key >> ${OVPN_CONFIG}.conf
    echo dh ${OVPN_SRV_DH} >> ${OVPN_CONFIG}.conf
    echo tls-auth ${OVPN_TLSAUTH}.key 0 >> ${OVPN_CONFIG}.conf
    echo server 10.8.0.0 255.255.255.0 >> ${OVPN_CONFIG}.conf
    echo ifconfig-pool-persist ipp.txt >> ${OVPN_CONFIG}.conf #maintain record client/virtual IP
    echo client-to-client >> ${OVPN_CONFIG}.conf
    echo keepalive 10 120 >> ${OVPN_CONFIG}.conf
    echo cipher AES-256-CBC >> ${OVPN_CONFIG}.conf
    echo auth SHA512 >> ${OVPN_CONFIG}.conf
    echo persist-key >> ${OVPN_CONFIG}.conf
    echo persist-tun >> ${OVPN_CONFIG}.conf
    echo log /var/log/openvpn/openvpn.log >> ${OVPN_CONFIG}.conf
    echo status /var/log/openvpn/openvpn-status.log >> ${OVPN_CONFIG}.conf
    echo verb 9 >> ${OVPN_CONFIG}.conf
    echo explicit-exit-notify 1 >> ${OVPN_CONFIG}.conf

openvpn --mktun --dev tun1
ip link set tun1 up
ip addr add 10.0.0.1/24 dev tun1

"$@"
