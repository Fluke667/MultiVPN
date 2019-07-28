#!/bin/bash

cat > /etc/gqserver.json <<EOF
{
        "WebServerAddr":"${GQ_WEBSRVADDR}",
        "Key":"${GQ_KEY}"
}
EOF

    cd ${DIR_TMP}
    wget  -q -O ${GQ_FILE} ${GQ_URL}
    chmod +x ${GQ_FILE}
    mv ${GQ_FILE} /usr/bin/gq-server
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] GoQuiet Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] GoQuiet installation failed.."
        echo
        exit 1
    fi
