#!/bin/sh

chmod u+x /config/init/openssh.sh &
chmod u+x /config/init/openssl.sh &
chmod u+x /config/init/openvpn.sh &
chmod u+x /config/init/shadowsocks.sh &
chmod u+x /config/init/tinc.sh &
chmod u+x /config/init/stunnel.sh &
chmod u+x /config/init/tor.sh &
/config/init/openssh.sh &
/config/init/openssl.sh &
/config/init/openvpn.sh &
/config/init/shadowsocks.sh &
/config/init/tinc.sh &
/config/init/stunnel.sh &
/config/init/tor.sh
