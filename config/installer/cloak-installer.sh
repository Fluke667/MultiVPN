#!/bin/bash

cat > /etc/shadowsocks-libev/ckconfig.json <<EOF
{
	"UID":"AdminUID",
	"PublicKey":"PublicKey",
	"ServerName":"ServerName",
	"TicketTimeHint":3600,
	"NumConn":4,
	"MaskBrowser":"firefox"
}
EOF


    cd /tmp
    wget  -q -O ${CLOAK_FILE} ${CLOAK_URL}
    chmod +x ${CLOAK_FILE}
    mv ${CLOAK_FILE} /usr/bin/ck-server
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] Cloak Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] Cloak installation failed.."
        echo
        exit 1
    fi
