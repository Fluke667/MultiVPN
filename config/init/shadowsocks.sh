#!/bin/sh

rngd -r /dev/urandom

# ss config
    cat > ${SSLIBEV_CONFIG}/standalone.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}"
    }
    EOF

# ss + v2ray-plugin config
   & cat > ${SSLIBEV_CONFIG}/v2ray_ws_http.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"v2ray-plugin",
        "plugin_opts":"server"
    }
    EOF

   & cat > ${SSLIBEV_CONFIG}/v2ray_ws_tls_cdn.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"v2ray-plugin",
        "plugin_opts":"server;tls;host=${V2RAY_HOST};cert=${V2RAY_CRT};key=${V2RAY_KEY}"
    }
    EOF

    cat > ${SSLIBEV_CONFIG}/v2ray_quic_tls_cdn.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE1:-tcp_only}",
        "plugin":"v2ray-plugin",
        "plugin_opts":"server;mode=quic;host=${V2RAY_HOST};cert=${V2RAY_CRT};key=${V2RAY_KEY}"
    }
    EOF

    cat > ${SSLIBEV_CONFIG}/v2ray_ws_tls_web.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"v2ray-plugin",
        "plugin_opts":"server;path=${V2RAY_BIN};loglevel=none"
    }
    EOF

    cat > ${SSLIBEV_CONFIG}/v2ray_ws_tls_web_cdn.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"v2ray-plugin",
        "plugin_opts":"server;path=${V2RAY_BIN};loglevel=none"
    }
    EOF

# kcptun config (Standalone)
    cat > ${SSLIBEV_CONFIG}/kcptun_standalone.json<<-EOF
    {
        "listen": ":${KCP_LISTEN_PORT}",
        "target": "${KCP_TARGET}:${KCP_TARGET_PORT}",
        "key": "${KCP_KEY}",
        "crypt": "${KCP_CRYPT}",
        "mode": "${KCP_MODE}",
        "mtu": ${KCP_MTU},
        "sndwnd": ${KCP_SNDWND},
        "rcvwnd": ${KCP_RCVWND},
        "datashard": ${KCP_DATASHARD},
        "parityshard": ${KCP_PARITYSHARD},
        "dscp": ${KCP_DSCP},
        "nocomp": ${KCP_NOCOMP}
    }
    EOF

# ss + simple-obfs
    cat > ${SSLIBEV_CONFIG}/obfs_http.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"obfs-server",
        "plugin_opts":"obfs=${OBFS_HTTP}"
    }
    EOF

    cat > ${SSLIBEV_CONFIG}/obfs_tls.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"obfs-server",
        "plugin_opts":"obfs=${OBFS_TLS}"
    }
    EOF

# ss + goquiet
    cat > ${SSLIBEV_CONFIG}/goquiet.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"gq-server",
        "plugin_opts":"WebServerAddr=${GQ_WEBSRVADDR};Key=${GQ_KEY}"
    }
    EOF

# ss + cloak config
    cat > ${SSLIBEV_CONFIG}/cloak.json<<-EOF
    {
        "server":"${SS_SERVER_ADDR:-0.0.0.0}",
        "server_port":${SS_SERVER_PORT:-8388},
        "password":"${SS_PASSWORD:-MyPass}",
        "timeout":${SS_TIMEOUT:-300},
        "user":${SS_SYSUSER:-nobody},
        "method":"${SS_METHOD:-aes-256-gcm}",
        "local_address":"${SS_LOCAL_ADDR:-127.0.0.1}",
        "local_port":${SS_LOCAL_PORT:-1080},
        "fast_open":${SS_FASTOPEN:-true},
        "reuse_port":${SS_REUSE_PORT:-true},
        "nameserver":"${SS_DNS:-1.1.1.1,1.0.0.1}",
        "mode":"${SS_MODE3:-tcp_and_udp}",
        "plugin":"ck-server",
        "plugin_opts":"WebServerAddr=${CLOAK_WEBSRVADDR};PrivateKey=${CLOAK_PRIVKEY};AdminUID=${CLOAK_UID};DatabasePath=${CLOAK_PATH}/userinfo.db;BackupDirPath=${CLOAK_PATH}/db-backup"
    }
    EOF

cat > ${SSLIBEV_CONFIG}/cloak-server-NC.json <<EOF
{
    "UID":"${CLOAK_UID}",
    "PublicKey":"${CLOAK_PUBKEY}",
    "ServerName":"${CLOAK_SERVNAME}",
    "TicketTimeHint":${CLOAK_TTH},
    "NumConn":${CLOAK_NUMMCONN},
    "MaskBrowser":"${CLOAK_BROWSER}"
}
EOF

cat > ${SSLIBEV_CONFIG}/kcptun-NC.json <<EOF
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

$@
