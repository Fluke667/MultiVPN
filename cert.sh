#!/bin/sh

openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /etc/ipsec.d/vpn-server.crt \
            -keyout /etc/ipsec.d/vpn-server.key \
            -subj "/C=$CRT_CN/ST=$CRT_ST/L=$CRT_LOC/O=$CRT_NAME/OU=$CRT_ORG/CN=$CRT_DOM"
