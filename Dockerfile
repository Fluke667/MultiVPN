#FROM golang:1.12-alpine3.10 AS builder
#RUN apk --no-cache add git build-base
#RUN mkdir -p /go /go/bin /go/src && \
#    go get -v git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy && \
#    go get -v git.torproject.org/pluggable-transports/meek.git/meek-server && \
#    go get -v git.torproject.org/pluggable-transports/snowflake.git/server && \
#    go get -v git.torproject.org/pluggable-transports/snowflake.git/broker

FROM fluke667/alpine
#COPY --from=builder /go/bin/obfs4proxy /usr/bin/
#COPY --from=builder /go/bin/meek-server /usr/bin/
#COPY --from=builder /go/bin/server /usr/bin/snowflake
#COPY --from=builder /go/bin/broker /usr/bin/
RUN apk add --update --no-cache alpine-baselayout alpine-base busybox openrc musl musl-dev geoip \
    openssl ca-certificates make shadow openssh openvpn bash nano sudo dcron upx patch gmp multirun \
    libsodium curl python3 python3-dev gnupg sqlite sqlite-libs sqlite-dev readline bzip2 libev libbz2 \
    expat gdbm xz-dev libffi libffi-dev libc-dev mbedtls runit tor torsocks pwgen rng-tools stunnel \
    libxslt-dev w3m c-ares zlib pcre coreutils libc6-compat libstdc++ lzo libpcap ncurses-static && \
    #rsyslog logrotate util-linux findutils grep nodejs npm && \
    apk update && apk add --no-cache --virtual build-deps \
    autoconf automake build-base libev-dev libtool udns-dev libsodium-dev mbedtls-dev pcre-dev c-ares-dev readline-dev \
    linux-headers curl openssl-dev zlib-dev git libcork-dev libbloom-dev ipset-dev gcc g++ gmp-dev lzo-dev libpcap-dev && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh asyncio cffi cryptography pproxy pycparser pycryptodome setuptools six aiodns aiohttp maxminddb \
    obfsproxy proxybroker && \
### Compile Section 1 - Files & Directories
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /run/openvpn /etc/shadowsocks-libev \ 
    /etc/tinc/ /etc/tinc/$TINC_NETNAME /etc/tinc/$TINC_NETNAME/hosts /var/log/tinc/ && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid && \
### Compile Section 3A - Get & Configure & Make Files
    cd /tmp && git clone --depth=1 ${SSLIBEV_DL} && \
    cd shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr --disable-documentation > /dev/null && make && \
    make install && \
    cd /tmp && wget ${TINC_DL} && tar -xzvf tinc-${TINC_VER}.tar.gz && \
    cd tinc-${TINC_VER} && ./configure --prefix=/usr --enable-jumbograms --enable-tunemu --sysconfdir=/etc --localstatedir=/var > /dev/null && make && sudo make install && \
### Clean Up all
    #rm -rf /var/cache/apk/*
    apk del build-deps
   
#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8090 8080 8070
# ORPort, DirPort, SocksPort
EXPOSE 9001 9030 9050
# shadowsocks-libev
EXPOSE 8388
#ObfsproxyPort, MeekPort
EXPOSE 54444 7002
#Proxybroker
EXPOSE 8888
#Tinc
EXPOSE 655
                
 


COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

VOLUME ["/config"]
VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/etc/tinc"]
VOLUME ["/var/www"]




RUN sh /config/installer.sh && sh /config/init/openssh.sh && sh /config/init/openssl.sh && sh /config/init/openvpn.sh && \
sh /config/init/shadowsocks.sh && sh /config/init/stunnel.sh && sh /config/init/tinc.sh && sh /config/init/tor.sh


#RUN rc-update add local default
#COPY ./installer.sh /etc/local.d/installer.sh


#RUN multirun -v "sh /config/init/openssh.sh" "sh /config/init/openssl.sh" "sh /config/init/openvpn.sh" "sh /config/init/shadowsocks.sh" "sh /config/init/stunnel.sh" "sh /config/init/tinc.sh" "sh /config/init/tor.sh"
#RUN multirun -v "sh /config/installer.sh" "sh /config/init/tinc.sh" 
#"sh /config/init/tor.sh"
#COPY /config/installer.sh /config/installer.sh
#RUN chmod a+x /config/installer.sh && /config/installer.sh
#COPY ./config/init.sh /config/init.sh
#RUN chmod a+x /config/init.sh && /config/init.sh


#ADD runit /sbin/
#RUN chmod a+x /sbin/runit
#CMD ["runit"]

ADD entry /sbin/
RUN chmod a+x /sbin/entry
ENTRYPOINT ["entry"]
