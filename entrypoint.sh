#!/bin/sh
set -e

#privoxy /etc/privoxy/config && ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/privoxy.json

sslocal -s $PRV_SERVER -p $PRV_SERVER_PORT -l $PRV_LOCAL_PORT -k $PRV_PASS -m $PRV_METHOLD -a $PRV_USER-d start -c $PRV_CONF 
privoxy --no-daemon /etc/privoxy/config


