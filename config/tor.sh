#!/bin/sh
set -o errexit

echo " ---> Generate torrc.conf Config File"
         rm ${TOR_CONF}.conf
    echo User tord > ${TOR_CONF}.conf
    #echo Nickname MyName >> ${TOR_CONF}.conf
    #echo ContactInfo noreply@mymail.com >> ${TOR_CONF}.conf
    echo DataDirectory /var/lib/tor >> ${TOR_CONF}.conf
    echo ORPort 9001 >> ${TOR_CONF}.conf
    echo #ORPort [IPv6-address]:9001 >> ${TOR_CONF}.conf
    echo #DirPort 9030 >> ${TOR_CONF}.conf
    echo ExitPolicy reject *:* >> ${TOR_CONF}.conf
    echo ExitPolicy reject6 *:* >> ${TOR_CONF}.conf
    echo SocksPort 9050 >> ${TOR_CONF}.conf
    echo #ControlSocket 0 >> ${TOR_CONF}.conf
    echo RelayBandwidthRate 1 MB >> ${TOR_CONF}.conf
    echo RelayBandwidthBurst 1 MB >> ${TOR_CONF}.conf
    echo AccountingMax 1 GBytes >> ${TOR_CONF}.conf
    echo ControlPort 9051 >> ${TOR_CONF}.conf
    echo HashedControlPassword $TOR_PASS >> ${TOR_CONF}.conf
    echo #CookieAuthentication 1 >> ${TOR_CONF}.conf
    echo #BridgeRelay 1 >> ${TOR_CONF}.conf
    echo #PublishServerDescriptor 0 >> ${TOR_CONF}.conf
echo " ---> Generate torsocks.conf Config File"
         rm ${TOR_SOCKS}.conf
    echo TorAddress 127.0.0.1 > ${TOR_SOCKS}.conf
    echo TorPort 9050 >> ${TOR_SOCKS}.conf
    echo OnionAddrRange 127.42.42.0/24 >> ${TOR_SOCKS}.conf
    echo SOCKS5Username $TORSOCKS_USERNAME >> ${TOR_SOCKS}.conf
    echo SOCKS5Password $TORSOCKS_PASSWORD >> ${TOR_SOCKS}.conf
    echo #AllowInbound 1 >> ${TOR_SOCKS}.conf
    echo #AllowOutboundLocalhost 1 >> ${TOR_SOCKS}.conf
    echo $COMMENT IsolatePID 1 >> ${TOR_SOCKS}.conf
    echo $TOR_ADD fte exec $TOR_FTE $TOR_OPT_FTE >> ${TOR_SOCKS}.conf
    echo $TOR_ADD meek exec $TOR_MEEK $TOR_OPT_MEEK >> ${TOR_SOCKS}.conf
    echo $TOR_ADD obfs3 exec $TOR_OBFS3 $TOR_OPT_OBFS3 >> ${TOR_SOCKS}.conf
    echo $TOR_ADD obfs4 exec $TOR_OBFS4 $TOR_OPT_OBFS4 >> ${TOR_SOCKS}.conf
    echo $TOR_ADD snowflake exec $TOR_SNOW $TOR_OPT_SNOW >> ${TOR_SOCKS}.conf


chmodf() { find $2 -type f -exec chmod -v $1 {} \;
}
chmodd() { find $2 -type d -exec chmod -v $1 {} \;
}

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
exec tor --RunAsDaemon 0 -f torrc.conf
