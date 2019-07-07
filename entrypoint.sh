#!/bin/sh
set -e

#privoxy /etc/privoxy/config && ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/privoxy.json

sslh -f -u sslh --listen $SSLH --ssh $SSLH_SSH --tls $SSLH_TLS --ovpn $SSLH_OVPN --tinc $SSLH_TINC --ssocks $SSLH_SSOCKS --any $SSLH_ANY &
ss-local -s $PRV_SERVER -p $PRV_SERVER_PORT -b $PRV_LOCAL -l $PRV_LOCAL_PORT -k $PRV_PASS -m $PRV_METHOLD -d start -c $PRV_CONF &
privoxy --no-daemon /etc/privoxy/config &
openvpn --config /etc/openvpn/server.conf &
#/opt/i2pd/bin/i2pd --http.enabled=1 --http.address=0.0.0.0 --http.port=8080 --httpproxy.enabled=1 --httpproxy.address=0.0.0.0 --httpproxy.port=4444
i2pd --nat=true --service --http.enabled=true --http.address=0.0.0.0 --httpproxy.enabled=true --httpproxy.address=0.0.0.0 --socksproxy.enabled=true --socksproxy.address=0.0.0.0 --sam.enabled=true --sam.address=0.0.0.0 &
   $@
      
      
        



