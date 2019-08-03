#!/bin/sh

echo " ---> Generate torrc Config File"
rm ${TOR_CONF}

cat > ${TOR_CONF}<<-EOF
User $TOR_USER
#echo Nickname MyName
#ContactInfo noreply@mymail.com
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

echo " ---> Generate torsocks.conf Config File"
rm ${TOR_SOCKS}.conf

cat > ${TOR_SOCKS}<<EOF
TorAddress 127.0.0.1 
TorPort 9050
OnionAddrRange 127.42.42.0/24
SOCKS5Username $TORSOCKS_USER
SOCKS5Password $TORSOCKS_PASS
#AllowInbound 1
#AllowOutboundLocalhost 1
$COMMENT IsolatePID 1
#$TOR_ADD meek exec $TOR_MEEK $TOR_OPT_MEEK
#$TOR_ADD obfs3 exec $TOR_OBFS3 $TOR_OPT_OBFS3
#$TOR_ADD obfs4 exec $TOR_OBFS4 $TOR_OPT_OBFS4
#$TOR_ADD snowflake exec $TOR_SNOW $TOR_OPT_SNOW
EOF

echo -e "\n========================================================"
# If DataDirectory, identity keys or torrc is mounted here,
# ownership needs to be changed to the TOR_USER user
chown -Rv ${TOR_USER}:${TOR_USER} /var/lib/tor
# fix permissions
chmodd 700 /var/lib/tor
chmodf 600 /var/lib/tor

if [ ! -e /tor-config-done ]; then
    touch /tor-config-done   # only run this once

    # Add Nickname from env variable or randomized, if none has been set
    if ! grep -q '^Nickname ' /etc/tor/torrc; then
        if [ ${TOR_NICK} == "Tor4" ] || [ -z "${TOR_NICK}" ]; then
            # if user did not change the default Nickname, genetrate a random pronounceable one
            RPW=$(pwgen -0A 8)
            TOR_NICK="Tor4${RPW}"
            echo "Setting random Nickname: ${TOR_NICK}"
        else
            echo "Setting chosen Nickname: ${TOR_NICK}"
        fi
        echo -e "\nNickname ${TOR_NICK}" >> /etc/tor/torrc
    fi

    # Add TOR_EMAIL from env variable, if none has been set in torrc
    if ! grep -q '^ContactInfo ' /etc/tor/torrc; then
        # if TOR_EMAIL is not null
        if [ -n "${TOR_EMAIL}" ]; then
            echo "Setting Contact Email: ${TOR_EMAIL}"
            echo -e "\nContactInfo ${TOR_EMAIL}" >> /etc/tor/torrc
        fi
    fi
fi

echo -e "\n========================================================"
# Display OS version, Tor version & torrc in log
echo -e "Alpine Version: \c" && cat /etc/alpine-release
tor --version
obfs4proxy -version
cat /etc/tor/torrc
echo -e "========================================================\n"

# execute from user
USER ${TOR_USER}
exec tor --RunAsDaemon 0 -f torrc
