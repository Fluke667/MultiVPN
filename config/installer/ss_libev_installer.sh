#!/bin/bash

    cd ${DIR_TMP}
    wget -q ${SSLIBEV_DL}
    tar zxf ${SSLIBEV_FILE}-${SSLIBEV_VER}.tar.gz
    cd ${SSLIBEV_FILE}-${SSLIBEV_VER}
    ./configure --disable-documentation && make && make install
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] shadowsocks-libev Successful installation.."
            else
        echo
        echo -e "\033[31m[ERROR] shadowsocks-libev installation failed.."
        echo
        exit 1
    fi
