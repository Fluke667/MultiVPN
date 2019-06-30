#!/bin/sh


# Basic Enviroment
export GOROOT=/usr/lib/go
export GOPATH=/go
export PATH=/go/bin:$PATH
export TZ=${TZ}

# shadowsocks-libev Enviroment
export SS_LIBEV_VERSION=v3.2.5
export KCP_VERSION=20190424
export SS_DL=https://github.com/shadowsocks/shadowsocks-libev.git 
export KCP_DL=https://github.com/xtaci/kcptun/releases/download/v${KCP_VERSION}/kcptun-linux-amd64-${KCP_VERSION}.tar.gz
export PLUGIN_OBFS_DL=https://github.com/shadowsocks/simple-obfs.git
export PLUGIN_V2RAY_DL=https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.0/v2ray-plugin-linux-amd64-8cea1a3.tar.gz
export PLUGIN_CLOAK_DL=https://github.com/cbeuw/cloak.git

# TOR Relay Enviroment
#export TOR_USER=MyUser
export TOR_USER='MyUser'
export TOR_NICK=MyNick
export TOR_EMAIL=My@email.com
export TOR_PASS=MyPass
export TORSOCKS_USERNAME=MyUser
export TORSOCKS_PASSWORD=MyPass

# sslh Enviroment
export LISTEN_IP=0.0.0.0
export LISTEN_PORT=443
export HTTPS_HOST=127.0.0.1
export HTTPS_PORT=8443
export SSH_HOST=127.0.0.1
export SSH_PORT=22
export OPENVPN_HOST=127.0.0.1
export OPENVPN_PORT=1194
export TINC_HOST=127.0.0.1
export TINC_PORT=655
#export XMPP_HOST=127.0.0.1
#export XMPP_PORT=5222
#export ADB_HOST=127.0.0.1
#export ADB_PORT=5037
export SHADOWSOCKS_HOST=127.0.0.1
export SHADOWSOCKS_PORT=8388
