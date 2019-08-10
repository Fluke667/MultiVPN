#!/bin/sh


cat >/etc/openvpn/obfs4proxy.conf<<-EOF
#
# Edit this file to your need and save it as /etc/openvpn/obfs4proxy-openvpn.conf
#
# If there are multiple enteries of the same kind, the last one wins the race
#

### General settings ###########################
# Mode of operation: client|server
# Transport: obfs4|obfs3|obfs2

MODE				server
TRANSPORT			obfs4
################################################


### obfs4 transport settings ###################
# Mode of IAT: 0-2
IAT_MODE			0
################################################


### General client mode settings ###############
# UPSTREAM_PROXY is needed if you are behind a proxy server

#CLIENT_UPSTREAM_PROXY		socks5://corp:proxy@129.0.0.1:1080
################################################


### obfs4 transport in client mode settings ####
# Either CERT or (NODE_ID && PUBLIC_KEY) should be specified
# You can extract the CERT from the obfs4proxy server,
#   by using 'obfs4proxy-openvpn --export-cert -' on the server

#CLIENT_REMOTE_CERT		ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/ABCDEF
#
#CLIENT_REMOTE_NODE_ID		0123456789abcdef0123456789abcdef01234567
#CLIENT_REMOTE_PUBLIC_KEY	0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
################################################


### General server mode settings ###############
# OBFS4_BIND_ADDR:OBFS4_BIND_PORT is the one that should also be set
#   as '--remote' in openvpn_client.conf.obfs4.
#   Bear in mind that using a port <1024 for OBFS4_BIND_PORT could fail,
#   due to OBFS4PROXY_UID setup.
# You likely don't need to change OPENVPN_BIND_ADDR:OPENVPN_BIND_PORT
#   but it can potentially be used to provide both obfuscated and
#   non-obfuscated openvpn traffic at the same time when OPENVPN_BIND_ADDR
#   is set to 0.0.0.0 .

SERVER_OBFS4_BIND_ADDR		0.0.0.0
SERVER_OBFS4_BIND_PORT		1516
SERVER_OPENVPN_BIND_ADDR	127.0.0.1
SERVER_OPENVPN_BIND_PORT	1515
################################################


### OpenVPN config file ########################
# In Debian based distros, it's better to not use .conf extension
#   if you're going to place it in default openvpn conf folders
#   to avoid accidental auto-startup by openvpn systemd unit.

OPENVPN_CONFIG_FILE		/etc/openvpn/openvpn.obfs4
################################################


### obfs4proxy settings ########################
# Don't change these unless you know what you're doing.
# WORKING_DIR is Absuloute path only.
# LOG_LEVEL: none|error|warn|info|debug
# LOG_IP is supposed to disable scrubbing addresses in the log
#   but doesn't really seem to work.

OBFS4PROXY_WORKING_DIR		/var/lib/obfs4proxy-openvpn
OBFS4PROXY_UID			obfs4-ovpn
OBFS4PROXY_GID			obfs4-ovpn
OBFS4PROXY_LOG_LEVEL		error
OBFS4PROXY_LOG_IP		false
################################################
EOF

cat >/etc/openvpn/openvpn.obfs4<<EOF
# Do NOT use these options:
#   "local" - will be set by the script
#   "port","lport" - will be set by the script
#   "proto" - will be set to tcp-server by the script
#   "daemon","inetd" - you can use obfs4proxy-openvpn.service.sample file
#     to make a proper systemd service instead.
#   options that shouldn't be used for TCP tunneling
#   options that can't generally be used on openvpn server side

# "server" mode can also be used. config just gets slightly more complex
mode		p2p

# tun device name
dev		tun_obfs4

# tun device local and remote IP
ifconfig	10.1.0.1 10.1.0.2

# Optimizing TCP tunnel
socket-flags	TCP_NODELAY

# While openvpn can be run as root, it's recommended to use a non-privileged
# user for it. The user 'nobody' should be readily available on all distros
# but its better if you use a dedicated user/group like 'openvpn/openvpn' instead.
user		nobody

# We need these as we are dropping privilege
persist-tun
persist-key

# It takes less than a second to setup a pre-shared key on the server:
# "openvpn --genkey --secret /etc/openvpn/secret.obfs4.key"
# This key needs to be imported to the client as well.
#
# For more advanced options, take a look at here:
# https://hamy.io/post/000f/obfs4proxy-openvpn-obfuscating-openvpn-traffic-using-obfs4/#cia-triad
#
secret		/etc/openvpn/secret.obfs4.key 0
EOF




cat >/etc/openvpn/client.obfs4<<EOF
# Do NOT use these options:
#   "proto" - will be set to tcp-client by the script
#   *proxy* - SOCKS5 proxy will be set by the script
#   "daemon","inetd" - you can use obfs4proxy-openvpn.service.sample file
#     to make a proper systemd service instead.
#   options that shouldn't be used for TCP tunneling
#   options that can't generally be used on openvpn client side

mode		p2p

# tun device name
dev		tun_obfs4

# Address and port of the obfs4proxy server
remote		10.11.12.13 1516

# tun device local and remote IP
ifconfig	10.1.0.2 10.1.0.1

# Optimizing TCP tunnel
socket-flags	TCP_NODELAY

# While openvpn can be run as root, it's recommended to use a non-privileged
# user for it. The user 'nobody' should be readily available on all distros
# but its better if you use a dedicated user like 'openvpn' instead.
# Furthermore, for obfs4, it is advised that openvpn and obfs4proxy share the same
# group on the client side (to not run into permission issues later on).
user		nobody
group		obfs4-ovpn

# We need these as we are dropping privilege
persist-tun
persist-key

# The imported key from the server.
#
# For more advanced options, take a look at here:
# https://hamy.io/post/000f/obfs4proxy-openvpn-obfuscating-openvpn-traffic-using-obfs4/#cia-triad
#
secret		/etc/openvpn/secret.obfs4.key 1
EOF
