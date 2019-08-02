#!/bin/sh

mkdir /etc/stunnel
rm $STUNNEL_CONF

cat > $STUNNEL_CONF <<-EOF
cert = ${STUNNEL_CRT}
key = ${STUNNEL_KEY}

setuid = stunnel
setgid = stunnel

pid = /var/run/stunnel/stunnel.pid

socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

CAfile = ${STUNNEL_CAFILE}
verifyChain = ${STUNNEL_VERIFY_CHAIN}

debug = ${STUNNEL_DEBUG}
output = /var/log/stunnel/stunnel.log
foreground = yes
client = ${STUNNEL_CLIENT}

[${STUNNEL_SERVICE}]
accept = ${STUNNEL_ACCEPT}
connect = ${STUNNEL_CONNECT}
delay = ${STUNNEL_DELAY}

EOF



exec stunnel "$@"
