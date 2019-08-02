FROM golang:1.12-alpine3.10 AS builder
RUN apk --no-cache add git build-base
RUN mkdir -p /go /go/bin /go/src && \
    go get -v git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy && \
    go get -v git.torproject.org/pluggable-transports/meek.git/meek-server && \
    go get -v git.torproject.org/pluggable-transports/snowflake.git/server && \
    go get -v git.torproject.org/pluggable-transports/snowflake.git/broker

FROM fluke667/alpine
COPY --from=builder /go/bin/obfs4proxy /usr/bin/
COPY --from=builder /go/bin/meek-server /usr/bin/
COPY --from=builder /go/bin/server /usr/bin/snowflake
COPY --from=builder /go/bin/broker /usr/bin/
RUN apk add --update --no-cache alpine-baselayout alpine-base busybox openrc musl musl-dev geoip \
    openssl ca-certificates make shadow openssh openvpn bash nano sudo dcron upx patch gmp \
    libsodium curl python3 python3-dev gnupg sqlite sqlite-libs sqlite-dev readline bzip2 libev libbz2 \
    expat gdbm xz-dev libffi libffi-dev libc-dev mbedtls runit tor torsocks pwgen rng-tools \
    libxslt-dev w3m c-ares zlib pcre coreutils libc6-compat libstdc++ && \
    #rsyslog logrotate util-linux findutils grep nodejs npm && \
    apk update && apk add --no-cache --virtual build-deps \
    autoconf automake build-base libev-dev libtool udns-dev libsodium-dev mbedtls-dev pcre-dev c-ares-dev \
    linux-headers curl openssl-dev zlib-dev git libcork-dev libbloom-dev ipset-dev gcc g++ gmp-dev && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh asyncio cffi cryptography pproxy pycparser pycryptodome setuptools six aiodns aiohttp maxminddb \
    obfsproxy proxybroker && \
### Compile Section 1 - Files & Directories
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /go /go/bin /go/src /run/openvpn /etc/shadowsocks-libev && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid /etc/shadowsocks-libev/shadowsocks.json && \
### Compile Section 2 - Add Groups and Users
    addgroup -S shadowsocks 2>/dev/null && adduser -S -D -h /var/log/shadowsocks -s /sbin/nologin -G shadowsocks -g shadowsocks shadowsocks 2>/dev/null && \
### Compile Section 3A - Get & Configure & Make Files
    cd /tmp && git clone --depth=1 ${SSLIBEV_DL} && \
    cd shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr --disable-documentation && make && \
    make install && rngd -r /dev/urandom && \
    cd /tmp && wget ${TINC_DL}${TINC_VER}.tar.gz -O tinc.tar.gz && tar -xf tinc.tar.gz --one-top-level --strip-components=1 && \
    cd tinc && ./configure --prefix=/usr --enable-jumbograms --enable-tunemu --sysconfdir=/etc --localstatedir=/var && make && sudo make install && \
### Clean Up all
    #rm -rf /var/cache/apk/*
    apk del build-deps
   
#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8090 8080 8070
# Tor & Torsocks
EXPOSE 9050 9051
# shadowsocks-libev
EXPOSE 8388
#Proxybroker
EXPOSE 8888
#Tinc
EXPOSE 6655
                
 


COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

VOLUME ["/config"]
VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/etc/tinc"]
VOLUME ["/var/www"]


ADD ./config /config

ADD installer /sbin/
RUN chmod a+x /sbin/installer
CMD ["/sbin/installer"]

ADD runit /sbin/
RUN chmod a+x /sbin/runit
CMD ["/sbin/runit"]

ADD entry /sbin/
RUN chmod a+x /sbin/entry
ENTRYPOINT ["/sbin/entry"]
