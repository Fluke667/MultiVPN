#!/bin/bash

cat > /etc/shadowsocks-libev/kcptun.json <<EOF
{
        "listen": "${KCP_LISTEN}",
        "target": "${KCP_TARGET}",
        "key": "${KCP_KEY}",
        "crypt": "${KCP_CRYPT}",
        "mode": "${KCP_MODE}",
        "mtu": ${KCP_MTU},
        "sndwnd": ${KCP_SNDWND},
        "rcvwnd": ${KCP_RCVWND},
        "datashard": ${KCP_DATASHARD},
        "parityshard": ${KCP_PARITYSHARD},
        "dscp": ${KCP_DSCP},
        "nocomp": ${KCP_NOCOMP},
        "acknodelay": false,
        "nodelay": 1,
        "interval": 40,
        "resend": 2,
        "nc": 1,
        "sockbuf": 16777217,
        "smuxbuf": 16777217,
        "keepalive": 10,
        "pprof":false,
        "quiet":false,
        "tcp":false
}  
EOF

    cd ${DIR_TMP}
    tar zxf ${KCPTUN_FILE}-${KCPTUN_VER}.tar.gz
    mv server_linux_amd64 ${KCPTUN_DIR}
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] kcptun Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] kcptun installation failed.."
        echo
        exit 1
    fi
