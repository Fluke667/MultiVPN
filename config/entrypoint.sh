#!/bin/sh

exec /config/openvpn.sh "$@"
exec /config/ssl.sh "$@"
exec /config/sshd.sh "$@"
