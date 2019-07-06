#!/bin/sh
set -e

#privoxy /etc/privoxy/config && ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/privoxy.json

ss-local -s $PRV_SERVER -p $PRV_SERVER_PORT -b $PRV_LOCAL -l $PRV_LOCAL_PORT -k $PRV_PASS -m $PRV_METHOLD -d start -c $PRV_CONF &
privoxy --no-daemon /etc/privoxy/config &
openvpn --config /etc/openvpn/server.conf &
sslh -f -u sslh --listen $SSLH --ssh $SSLH_SSH --tls $SSLH_TLS --ovpn $SSLH_OVPN --tinc $SSLH_TINC --ssocks $SSLH_SSOCKS --any $SSLH_ANY &
#/opt/i2pd/bin/i2pd --http.enabled=1 --http.address=0.0.0.0 --http.port=8080 --httpproxy.enabled=1 --httpproxy.address=0.0.0.0 --httpproxy.port=4444   
   $@
      
      
        



