#!/bin/sh

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

if [ ! -f "$OVPN_TLSAUTH_KEY" ]
then

  echo " ---> Generate Openvpn TLS-Auth Key"
  openvpn \
    --genkey --secret "$OVPN_TLSAUTH_KEY"
    
else
  echo "ENTRYPOINT: tlsauth.key already exists"       
fi
    
  echo " ---> Generate Openvpn file ${CLIENT_NAME}-emb.ovpn"
    echo client > ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo dev tun >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo proto udp >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo remote ${IP_ADDR} 1194 >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo cipher AES-256-CBC >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo auth SHA512 >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    #echo resolv-retry infinite >> ${CLIENT_NAME}.ovpn
    #echo redirect-gateway def1 >> ${CLIENT_NAME}.ovpn
    echo nobind >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    #echo comp-lzo yes >> ${CLIENT_NAME}.ovpn
    echo persist-key >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo persist-tun >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
	  echo user openvpn >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
	  echo group openvpn >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo verb 3 >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    #echo setenv ALLOW_PASSWORD_SAVE 0 >> ${CLIENT_NAME}.ovpn 
    #echo auth-user-pass >> ${CLIENT_NAME}.ovpn
    echo '<ca>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    cat ${CRT_CERT_DIR}/${CRT_CA_NAME}.pem >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo '</ca>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo '<cert>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    cat ${CRT_CERT_DIR}/${CLIENT_NAME}.crt >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo '</cert>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo '<key>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    cat ${CRT_CERT_DIR}/${CLIENT_NAME}.key >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn
    echo '</key>' >> ${OVPN_DIR}/${CLIENT_NAME}.ovpn

  echo " ---> Generate Openvpn file ${CLIENT_NAME}-file.ovpn"




#IP=$(grep '^server .*$' /etc/openvpn/server.conf | awk '{print $2}')


#/usr/sbin/openvpn --cd /etc/openvpn --config /etc/openvpn/server.conf --script-security 2


exec "$@"
