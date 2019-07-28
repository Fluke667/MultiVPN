#!/bin/bash

    cd ${DIR_TMP}
    wget  -q -O ${GOQUIET_FILE} ${GOQUIET_URL}
    chmod +x ${GOQUIET_FILE}
    mv ${GOQUIET_FILE} /usr/bin/gq-server
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] GoQuiet Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] GoQuiet installation failed.."
        echo
        exit 1
    fi
