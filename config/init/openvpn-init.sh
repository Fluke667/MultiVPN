#!/bin/sh


cp -r /usr/share/easy-rsa /etc/openvpn/

#mkdir -p /dev/net <<< done in pre-install.sh
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


openvpn --mktun --dev tun1
ip link set tun1 up
ip addr add 10.0.0.1/24 dev tun1

"$@"
