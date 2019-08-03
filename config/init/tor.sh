#!/bin/bash

addgroup -g 19001 -S $TOR_USER && adduser -u 19001 -G $TOR_USER -S $TOR_USER

rm ${TOR_CONF}

echo " ---> Generate torrc Config File"
cat > ${TOR_CONF}<<-EOF
User $TOR_USER
Nickname $TOR_NICK
ContactInfo $TOR_EMAIL
DataDirectory /var/lib/tor
ORPort 9001
#ORPort [IPv6-address]:9001
#DirPort 9030
ExitPolicy reject *:*
ExitPolicy reject6 *:*
SocksPort 9050
#ControlSocket 0
RelayBandwidthRate 1 MB
RelayBandwidthBurst 1 MB
AccountingMax 1 GBytes
ControlPort 9051
HashedControlPassword $TOR_PASS
#CookieAuthentication 1
#BridgeRelay 1
#PublishServerDescriptor 0
EOF


rm ${TOR_SOCKS}.conf

echo " ---> Generate torsocks.conf Config File"
cat > ${TORSOCKS_CONF_FILE}<<EOF
TorAddress 127.0.0.1 
TorPort 9050
OnionAddrRange 127.42.42.0/24
SOCKS5Username $TORSOCKS_USERNAME
SOCKS5Password $TORSOCKS_PASSWORD
AllowInbound $TORSOCKS_ALLOW_INBOUND
#AllowOutboundLocalhost 1
#IsolatePID 1
#$TOR_ADD meek exec $TOR_MEEK $TOR_OPT_MEEK
#$TOR_ADD obfs3 exec $TOR_OBFS3 $TOR_OPT_OBFS3
#$TOR_ADD obfs4 exec $TOR_OBFS4 $TOR_OPT_OBFS4
#$TOR_ADD snowflake exec $TOR_SNOW $TOR_OPT_SNOW
EOF


# If DataDirectory, identity keys or torrc is mounted here,
# ownership needs to be changed to the TOR_USER user
chown -Rv ${TOR_USER}:${TOR_USER} /var/lib/tor
# fix permissions
chmod -R 700 /var/lib/tor


"$@"
