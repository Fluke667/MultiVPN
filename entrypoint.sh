#!/bin/sh
set -e

exec privoxy /etc/privoxy/config && ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/privoxy.json
