#!/bin/bash

cat > /etc/shadowsocks-libev/ckconfig.json <<EOF
{
	"UID":"${CLOAK_UID}",
	"PublicKey":"${CLOAK_PUBKEY}",
	"ServerName":"${CLOAK_CLOAK_SERVNAME}",
	"TicketTimeHint":${CLOAK_TTH},
	"NumConn":${CLOAK_NUMMCONN},
	"MaskBrowser":"${CLOAK_BROWSER}"
}
EOF


    cd ${DIR_TMP}
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
