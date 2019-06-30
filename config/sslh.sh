#!/bin/sh

if [ "$@" != "" ]; then
  # This works if ARGS is specified in Dockerfile or if docker started with arguments, i.e.
  # docker run -ti --rm sslh some-command arguments
  exec "$@"
else

  # sslh v1.19c
  # usage:
  # 	sslh  [-v] [-i] [-V] [-f] [-n] [--transparent] [-F<file>]
  # 	[-t <timeout>] [-P <pidfile>] [-u <username>] [-C <chroot>] -p <add> [-p <addr> ...]
  # 	[--ssh <addr>]
  # 	[--openvpn <addr>]
  # 	[--tinc <addr>]
  # 	[--xmpp <addr>]
  # 	[--http <addr>]
  # 	[--ssl <addr>]
  # 	[--tls <addr>]
  # 	[--adb <addr>]
  # 	[--anyprot <addr>]
  # 	[--on-timeout <addr>]

  ARGS="--foreground --user nobody --pidfile /var/run/sslh.pid"
  [ ${TIMEOUT:--1} -gt 0 ]    && ARGS="${ARGS} --timeout ${TIMEOUT}"
  [ "${VERBOSE}" == "true" ]  && ARGS="${ARGS} --verbose"
  [ "${LISTEN_IP}" != "" ]    && ARGS="${ARGS} --listen ${LISTEN_IP}:${LISTEN_PORT:-443}"
  [ "${HTTPS_HOST}" != "" ]   && ARGS="${ARGS} --on-timeout ${HTTPS_HOST}:${HTTPS_PORT:-443} --ssl ${HTTPS_HOST}:${HTTPS_PORT:-443}"
  [ "${SSH_HOST}" != "" ]     && ARGS="${ARGS} --ssh ${SSH_HOST}:${SSH_PORT:-22}"
  [ "${OPENVPN_HOST}" != "" ] && ARGS="${ARGS} --openvpn ${OPENVPN_HOST}:${OPENVPN_PORT:-1194}"
  [ "${TINC_HOST}" != "" ]    && ARGS="${ARGS} --tine ${TINC_HOST}:${TINC_PORT:-655}"
  [ "${XMPP_HOST}" != "" ]    && ARGS="${ARGS} --xmpp ${XMPP_HOST}:${XMPP_PORT:-5222}"
  [ "${ADB_HOST}" != "" ]     && ARGS="${ARGS} --adb ${ADB_HOST}:${ADB_PORT:-5037}"

  exec /usr/sbin/sslh-fork ${ARGS}
fi
