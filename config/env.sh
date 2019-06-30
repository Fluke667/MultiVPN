#!/bin/sh

#
# https://github.com/moby/moby/issues/28617
#
export \
# Basic Enviroment
GOROOT=/usr/lib/go \
GOPATH=/go \
PATH=/go/bin:$PATH \
TZ=${TZ} \

# shadowsocks-libev Enviroment
SS_LIBEV_VERSION=v3.2.5 \
KCP_VERSION=20190424 \
SS_DL=https://github.com/shadowsocks/shadowsocks-libev.git \
KCP_DL=https://github.com/xtaci/kcptun/releases/download/v${KCP_VERSION}/kcptun-linux-amd64-${KCP_VERSION}.tar.gz \
PLUGIN_OBFS_DL=https://github.com/shadowsocks/simple-obfs.git \
PLUGIN_V2RAY_DL=https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.0/v2ray-plugin-linux-amd64-8cea1a3.tar.gz \
PLUGIN_CLOAK_DL=https://github.com/cbeuw/cloak.git \

# TOR Relay Enviroment
TOR_USER=MyUser \
TOR_NICK=MyNick \
TOR_EMAIL=My@email.com \
TOR_PASS=MyPass \
TORSOCKS_USERNAME=MyUser \
TORSOCKS_PASSWORD=MyPass \

# sslh Enviroment
LISTEN_IP=0.0.0.0 \
LISTEN_PORT=443 \
HTTPS_HOST=127.0.0.1 \
HTTPS_PORT=8443 \
SSH_HOST=127.0.0.1 \
SSH_PORT=22 \
OPENVPN_HOST=127.0.0.1 \
OPENVPN_PORT=1194 \
TINC_HOST=127.0.0.1 \
TINC_PORT=655 \
#XMPP_HOST=127.0.0.1 \
#XMPP_PORT=5222 \
#ADB_HOST=127.0.0.1 \
#ADB_PORT=5037 \
SHADOWSOCKS_HOST=127.0.0.1 \
SHADOWSOCKS_PORT=8388 \

# Stunnel Enviroment
STUNNEL_CLIENT=no \
STUNNEL_SERVICE=openvpn \
STUNNEL_ACCEPT=0.0.0.0:4911 \
STUNNEL_CONNECT=server:1194

exec "$@"
