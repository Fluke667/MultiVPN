#!/usr/bin/env sh

set -e

exec ss-server -v \
    -s ${SS_SERVER_ADDR:-0.0.0.0} \
    -p ${SS_SERVER_PORT:-8388} \
    -k ${SS_PASSWORD:-bob180180180} \
    -t ${SS_TIMEOUT:-300} \
    -m ${SS_METHOD:-chacha20} \
    -n ${SHADOWSOCKS_MAXOPENFILES:-1000} \
    -d ${SS_DNS:-1.1.1.1,1.0.0.1}
    --fast-open \
    --reuse-port \
    -u \
    --plugin ${SS_PLUGIN} \
    --plugin-opts ${SS_PLUGIN_OPTS}
