#!/bin/bash

    cd ${DIR_TMP}
    wget  -q ${V2RAY_DL}
    tar zxf ${V2RAY_FILE}-${V2RAY_VER}.tar.gz
    mv /tmp/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] v2ray-plugin Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] v2ray-plugin installation failed.."
        echo
        exit 1
    fi

