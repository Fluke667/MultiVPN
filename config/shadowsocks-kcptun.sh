#!/usr/bin/env sh

set -e

ss-server -v \
    -s ${SS_SERVER_ADDR:-0.0.0.0} \
    -p ${SS_SERVER_PORT:-8366} \
    -k ${SS_PASSWORD:-MyPass} \
    -t ${SS_TIMEOUT:-300} \
    -m ${SS_METHOD:-aes-256-gcm} \
    -n ${SS_MAXOPENFILES:-1000} \
    -d ${SS_DNS:-1.1.1.1,1.0.0.1} \
    --fast-open \
    --reuse-port \
    -u &&
kcpserver \
    -l :${KCP_SERVER_ADDR:-0.0.0.0} \
    -t 127.0.0.1:${SS_SERVER_PORT:-8366} \
    --key ${KCP_PASSWORD:-MyPass} \
    --crypt ${KCP_ENCRYPT:-salsa20} \
    --mode ${KCP_MODE:-fast2} \
    --mtu ${KCP_MTU:-1400} \
    --sndwnd ${KCP_SNDWND:-1024} \
    --rcvwnd ${KCP_RCVWND:-1024} \
    --dscp ${KCP_DSCP:-46} \
    --datashard ${KCP_DATASHARD:-10} \
    --parityshard ${KCP_PARITYSHARD:-0} \
    --sockbuf ${KCP_SOCKBUF:-16777216}
