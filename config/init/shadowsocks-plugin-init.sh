#!/bin/sh

    cd ${DIR_TMP}

    wget -q -O ${CLOAK_FILE} ${CLOAK_URL}
    chmod +x ${CLOAK_FILE}
    mv ${CLOAK_FILE} /usr/bin/ck-server
    if [ $? -eq 0 ]; then
        echo -e "${INFO} Cloak Successful installation.."
    else
        echo
        echo -e "${ERROR} Cloak installation failed.."
        echo
        exit 1
    fi

    wget -q -O ${GQ_FILE} ${GQ_URL}
    chmod +x ${GQ_FILE}
    mv ${GQ_FILE} /usr/bin/gq-server
    if [ $? -eq 0 ]; then
        echo -e "${INFO} GoQuiet Successful installation.."
    else
        echo
        echo -e "${ERROR} GoQuiet installation failed.."
        echo
        exit 1
    fi

    wget -q ${KCPTUN_DL}
    tar zxf ${KCPTUN_FILE}-${KCPTUN_VER}.tar.gz
    mv server_linux_amd64 /usr/bin/kcptun-server
    if [ $? -eq 0 ]; then
        echo -e "${INFO} kcptun Successful installation.."
    else
        echo
        echo -e "${ERROR} kcptun installation failed.."
        echo
        exit 1
    fi

       wget -q ${V2RAY_DL}
    tar zxf ${V2RAY_FILE}-${V2RAY_VER}.tar.gz
    mv /tmp/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
    if [ $? -eq 0 ]; then
        echo -e "${INFO} v2ray-plugin Successful installation.."
    else
        echo
        echo -e "${ERROR} v2ray-plugin installation failed.."
        echo
        exit 1
    fi


"$@"
