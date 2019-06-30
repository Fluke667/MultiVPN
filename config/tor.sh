#!/bin/sh
set -o errexit

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

# else default to run whatever the user wanted like "bash"
exec "$@"
