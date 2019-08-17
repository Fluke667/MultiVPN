#!/bin/sh

cd /config && chmod u+x * -R &
sh /config/installer.sh &
sh /config/init/openssl-init.sh &
sh /config/init/openssh-init.sh &
sh /config/init/openvpn-init.sh &
sh /config/init/tinc-init.sh & 
sh /config/conf/openssl-conf.sh &
sh /config/conf/openssh-conf.sh &
sh /config/conf/openvpn-conf.sh &
sh /config/conf/shadowsocks-conf.sh &
sh /config/conf/stunnel-conf.sh &
sh /config/conf/tinc-conf.sh &
sh /config/conf/tor-conf.sh &
sh /config/conf/cloak-conf.sh &
sh /config/conf/strongswan-conf.sh &
sh /config/conf/obfs4proxy-ovpn-conf.sh &
sh /config/conf/i2pd-conf.sh &
cp /config/bin/microsocks /usr/bin &
cp /config/bin/obfs4proxy-openvpn /usr/bin &
cp /config/bin/ovpn /usr/bin &

#sslh -f -u sslh --listen $SSLH --ssh $SSLH_SSH --tls $SSLH_TLS --ovpn $SSLH_OVPN --tinc $SSLH_TINC --ssocks $SSLH_SSOCKS --any $SSLH_ANY &
#ss-local -s $PRV_SERVER -p $PRV_SERVER_PORT -b $PRV_LOCAL -l $PRV_LOCAL_PORT -k $PRV_PASS -m $PRV_METHOLD -d start -c $PRV_CONF &
#/opt/i2pd/bin/i2pd --http.enabled=1 --http.address=0.0.0.0 --http.port=8080 --httpproxy.enabled=1 --httpproxy.address=0.0.0.0 --httpproxy.port=4444
#i2pd --nat=true --service --http.enabled=true --http.address=0.0.0.0 --httpproxy.enabled=true --httpproxy.address=0.0.0.0 --socksproxy.enabled=true --socksproxy.address=0.0.0.0 --sam.enabled=true --sam.address=0.0.0.0 &
#tinc --net=$NETWORK start --no-detach --debug=$DEBUG --logfile=/var/log/tinc/tinc.$NETWORK.log
#exec ss-server -v -s ${SS_SERVER_ADDR} -p ${SS_SERVER_PORT} -l ${SS_LOCAL_PORT} -k ${SS_PASSWORD} -t ${SS_TIMEOUT} -m ${SS_METHOD} -n ${SS_MAXOPENFILES} -d ${SS_DNS} --fast-open --reuse-port -u 
#exec ss-local -u --fast-open -c /etc/shadowsocks-libev/privoxy.json
#ss-tunnel -c /etc/shadowsocks-libev/sstunnel_tor.json &
#php-fpm -D && lighttpd -D -f /etc/lighttpd/lighttpd.conf


sslh-select -f -u root --listen $SSLH_LISTEN --ssh $SSLH_SSH --tls $SSLH_TLS --openvpn $SSLH_OVPN --anyprot $SSLH_TINC --anyprot $SSLH_SSOCKS &
pproxy -l socks4+socks5://:8010#$PPROXY_USER:$PPROXY_PASS &
pproxy -l http://:8020#$PPROXY_USER:$PPROXY_PASS &
pproxy -l ss://aes-256-gcm:yDRHHo1PjnolIVQHF3H4cpuL45udo7aHOco+Og==@:8030 &
#i2pd --datadir=$DATA_DIR --reseed.verify=true --upnp.enabled=false --http.enabled=true --http.address=0.0.0.0 --httpproxy.enabled=true --httpproxy.address=0.0.0.0 --socksproxy.enabled=true --socksproxy.address=0.0.0.0 --sam.enabled=true --sam.address=0.0.0.0 &
#peervpn /etc/peervpn/peervpn.conf &
microsocks -1 -i $MICRO_LISTEN -p $MICRO_PORT -u $MICRO_USER -P $MICRO_PASS -b $MICRO_BINDADDR &
openvpn --writepid /run/openvpn/ovpn.pid --cd /etc/openvpn --config /etc/openvpn/openvpn.conf &
proxybroker serve --host 0.0.0.0 --port 8888 --types HTTP HTTPS --lvl High &
tinc --net=$TINC_NETNAME --config=$TINC_DIR/$TINC_NETNAME --debug=$TINC_DEBUG --logfile=$TINC_LOG &
ss-server -c /etc/shadowsocks-libev/standalone.json &
tor --RunAsDaemon 0 -f /etc/tor/torrc &
kcptun-server -c /etc/shadowsocks-libev/kcptun_standalone.json &
obfs-server --fast-open -a nobody -s $OBFS_SERVER -p $OBFS_PORT -d $OBFS_DNS --obfs $OBFS_OPTS -r $OBFS_FORWARD &
ipsec start --nofork


$@
      
      
        



