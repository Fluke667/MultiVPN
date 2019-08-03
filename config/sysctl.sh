#!/bin/sh

set -e

# Sysctl Configs
sysctl -e -q -w kernel.msgmnb=65536
sysctl -e -q -w kernel.msgmax=65536
sysctl -e -q -w kernel.shmmax=68719476736
sysctl -e -q -w kernel.shmall=4294967296
sysctl -e -q -w net.ipv4.ip_forward=1
sysctl -e -q -w net.ipv4.conf.all.accept_source_route=0
sysctl -e -q -w net.ipv4.conf.all.accept_redirects=0
sysctl -e -q -w net.ipv4.conf.all.send_redirects=0
sysctl -e -q -w net.ipv4.conf.all.rp_filter=0
sysctl -e -q -w net.ipv4.conf.default.accept_source_route=0
sysctl -e -q -w net.ipv4.conf.default.accept_redirects=0
sysctl -e -q -w net.ipv4.conf.default.send_redirects=0
sysctl -e -q -w net.ipv4.conf.default.rp_filter=0
sysctl -e -q -w net.ipv4.conf.ens3.send_redirects=0
sysctl -e -q -w net.ipv4.conf.ens3.rp_filter=0

exec "$@"

