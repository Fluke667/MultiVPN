#!/bin/sh

set -ex

sh ./config/init/openssh.sh &
sh ./config/init/openssl.sh & 
sh ./config/init/openvpn.sh &
sh ./config/init/shadowsocks.sh &
sh ./config/init/stunnel.sh &
sh ./config/init/tinc.sh &
sh ./config/init/tor.sh &
sh ./config/init/cloak.sh &
sh ./config/init/strongswan.sh

        echo -e "\033[32m[INFO] Successful Init.."
    else
        echo
        echo -e "\033[31m[ERROR] Init Failed .."
        echo
        exit 1
    fi

"$@"
