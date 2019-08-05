FROM fluke667/alpine-golang:latest AS gobuilder
FROM fluke667/alpine-builder AS appbuilder
FROM fluke667/alpine
COPY --from=gobuilder /go/bin/obfs4proxy/ /usr/bin/ \ 
                      /go/bin/meek-server/ /usr/bin/ \ 
                      /go/bin/server/ /usr/bin/ \ 
                      /go/bin/broker/ /usr/bin/
COPY --from=appbuilder /usr/bin/ck-server/ /usr/bin/ \
                       /usr/bin/gq-server/ /usr/bin/ \
                       /usr/bin/kcptun-server/ /usr/bin/ \
                       /usr/bin/v2ray-plugin/ /usr/bin/
                       

#COPY --from=gobuilder /go/bin/meek-server /usr/bin
#COPY --from=gobuilder /go/bin/server /usr/bin/snowflake
#COPY --from=gobuilder /go/bin/broker /usr/bin
#COPY --from=appbuilder /usr/bin/ck-server /usr/bin
#COPY --from=appbuilder /usr/bin/gq-server /usr/bin
#COPY --from=appbuilder /usr/bin/kcptun-server /usr/bin
#COPY --from=appbuilder /usr/bin/v2ray-plugin /usr/bin

RUN apk add --update --no-cache alpine-baselayout alpine-base busybox openrc musl geoip \
    openssl ca-certificates shadow openssh openvpn bash nano sudo dcron upx patch gmp multirun \
    libsodium python3 python3-dev gnupg readline bzip2 libev libbz2 sqlite sqlite-libs \
    expat gdbm xz xz-libs libffi libffi-dev libc-dev mbedtls runit tor torsocks pwgen rng-tools stunnel \
    libxslt-dev w3m c-ares zlib pcre coreutils libc6-compat libstdc++ lzo libpcap ncurses-static zstd zstd-libs \
    boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams musl-utils && \
    #Testing and Third Repos:
    #meek obfs4proxy shadowsocks-libev libcork libcorkipset libbloom simple-obfs && \
    apk update && apk add --no-cache --virtual build-deps \
    autoconf automake build-base make libev-dev libtool udns-dev libsodium-dev mbedtls-dev pcre-dev c-ares-dev readline-dev xz-dev \
    linux-headers curl openssl-dev zlib-dev git gcc g++ gmp-dev lzo-dev libpcap-dev zstd-dev \
    musl-dev curl  boost-dev miniupnpc-dev sqlite-dev gd-dev geoip-dev libmaxminddb-dev libxml2-dev libxslt-dev paxmark perl-dev pkgconf && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh asyncio cffi cryptography pproxy pycparser pycryptodome setuptools six aiodns aiohttp maxminddb \
    obfsproxy proxybroker && \
### Compile Section 1 - Files & Directories
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /run/openvpn /etc/shadowsocks-libev \ 
    /etc/tinc/ /etc/tinc/$TINC_NETNAME /etc/tinc/$TINC_NETNAME/hosts /var/log/tinc/ /home/i2pd /home/i2pd/data /etc/certs/i2pd && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid && \
### Adduser 
    adduser -S -h /home/i2pd i2pd && chown -R i2pd:nobody /home/i2pd && \
### Compile Section 3A - Get & Configure & Make Files
    #cd /tmp && git clone ${PURPLEI2P_DL} && \
    #cd i2pd && make && cp -R contrib/certificates/* /etc/certs/i2pd && cp i2pd /usr/bin && \
    #cd /tmp && git clone --depth=1 ${SSLIBEV_DL} && \
    #cd shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr --disable-documentation > /dev/null && make && \
    #make install && \
    #cd /tmp && wget ${TINC_DL} && tar -xzvf tinc-${TINC_VER}.tar.gz && \
   #cd tinc-${TINC_VER} && ./configure --prefix=/usr --enable-jumbograms --enable-tunemu --sysconfdir=/etc --localstatedir=/var > /dev/null && make && sudo make install && \
### Clean Up all
    #rm -rf /var/cache/apk/*
    apk --no-cache --purge del build-deps
    
   
#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8010 8020 8030
# SocksPort, Control, ORPort, DirPort, 
EXPOSE 9050 9051 9001 9030
# shadowsocks-libev
EXPOSE 8388
#O bfsproxyPort, MeekPort
EXPOSE 54444 7002
# Proxybroker
EXPOSE 8888
# Tinc
EXPOSE 655
# i2pd
EXPOSE 7070 4444 4447 7656 2827 7654 7650
# Nginx/PHP7/SQlite
EXPOSE 8080

                

COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/etc/tinc"]
VOLUME ["/var/www/html"]
VOLUME ["/home/i2pd"]
VOLUME ["/etc/ssh"]


ADD config /config
RUN sh /config/installer.sh && sh /config/init/openssh.sh && sh /config/init/openssl.sh && sh /config/init/openvpn.sh && \
    sh /config/init/shadowsocks.sh && sh /config/init/stunnel.sh && sh /config/init/tinc.sh && sh /config/init/tor.sh && \
    sh /config/init/cloak.sh


COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
