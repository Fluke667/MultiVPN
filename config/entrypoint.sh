#!/bin/sh

#exec /config/openvpn.sh &
#exec /config/ssl.sh &
#exec /config/sshd.sh &
#exec "$@"
/config/openvpn.sh "$@" &
/config/ssl.sh "$@" &
/config/sshd.sh "$@" &
exec "$@"

