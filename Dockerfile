FROM fluke667/alpine-golang:latest AS gobuilder
FROM fluke667/alpine-builder AS appbuilder
FROM fluke667/alpine
COPY --from=gobuilder /go/bin/obfs4proxy /usr/bin/ \ 
                      /go/bin/meek-server /usr/bin/ \ 
                      /go/bin/server /usr/bin/ \ 
                      /go/bin/broker /usr/bin/
COPY --from=appbuilder /usr/bin/ss-local /usr/bin/ \
                       /usr/bin/ss-manager /usr/bin/ \
                       /usr/bin/ss-nat /usr/bin/ \
                       /usr/bin/ss-redir /usr/bin/ \
                       /usr/bin/ss-server /usr/bin/ \
                       /usr/bin/ss-tunnel /usr/bin/ \
                       #/usr/bin/microsocks /usr/bin/ \
                       /usr/sbin/tinc /usr/bin/ \
                       /usr/sbin/tincd /usr/bin/
                       


RUN apk add --update --no-cache alpine-baselayout alpine-base busybox openrc musl geoip iproute2 perl \
    openssl ca-certificates shadow openssh bash nano sudo dcron upx patch gmp multirun strongswan \
    libsodium python3 python3-dev gnupg readline bzip2 libev libbz2 sqlite sqlite-libs musl-utils \
    expat gdbm xz xz-libs libffi libffi-dev libc-dev mbedtls runit tor torsocks pwgen rng-tools stunnel util-linux \
    libxslt-dev w3m c-ares zlib pcre coreutils libc6-compat libstdc++ lzo libpcap ncurses-static zstd zstd-libs \ 
    nginx php7-fpm openvpn easy-rsa openvpn-auth-pam google-authenticator opensc p11-kit && \
    #Testing and Third Repos:
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache \
    lcov valgrind libcork libcorkipset libbloom i2pd sslh peervpn pamtester && \
    # meek obfs4proxy shadowsocks-libev simple-obfs && \
    apk update && apk add --no-cache --virtual build-deps \
    autoconf automake build-base make libev-dev libtool udns-dev libsodium-dev mbedtls-dev pcre-dev c-ares-dev readline-dev xz-dev \
    linux-headers curl openssl-dev zlib-dev git gcc g++ gmp-dev lzo-dev libpcap-dev zstd-dev paxmark perl-dev pkgconf valgrind \
    musl-dev curl  boost-dev miniupnpc-dev sqlite-dev gd-dev geoip-dev libmaxminddb-dev libxml2-dev libxslt-dev libconfig-dev \
    perl-io-socket-inet6 perl-conf-libconfig && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh asyncio cffi cryptography pproxy pycparser pycryptodome setuptools six aiodns aiohttp maxminddb \
    obfsproxy proxybroker && \
### Files & Directories
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /run/openvpn /etc/openvpn/ccd /var/log/openvpn \
    /etc/shadowsocks-libev /etc/tinc/ /etc/tinc/$TINC_NETNAME /etc/tinc/$TINC_NETNAME/hosts /var/log/tinc/ /home/i2pd /home/i2pd/data /etc/certs/i2pd && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid && \
### Adduser 
### Clean Up all
    #rm -rf /var/cache/apk/*
    apk --no-cache --purge del build-deps
    
   
# sslh Multiplexer
EXPOSE 443 8443
#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8010 8020 8030
# SocksPort, Control, ORPort, DirPort, 
EXPOSE 9050 9051 9001 9030
# shadowsocks-libev
EXPOSE 8388
# ObfsproxyPort, MeekPort
EXPOSE 54444 7002
# Proxybroker
EXPOSE 8888
# Tinc
EXPOSE 655
# i2pd
EXPOSE 7070 4444 4447 7656 2827 7654 7650
# Peervpn
EXPOSE 7000
# Nginx/PHP7/SQlite
EXPOSE 8080 9090
# PPTP
EXPOSE 500 4500


                
COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/etc/tinc"]
VOLUME ["/var/www/html"]
VOLUME ["/home/i2pd"]
VOLUME ["/etc/ssh"]
VOLUME ["/etc/ppp"]


ADD config /config


COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
