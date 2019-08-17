#!/bin/sh

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
    
    
"$@"
