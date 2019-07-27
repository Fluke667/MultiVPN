FROM fluke667/alpine
RUN apk add --update --no-cache alpine-baselayout alpine-base busybox openrc musl musl-dev \
    openssl ca-certificates make shadow openssh openvpn bash nano sudo dcron upx patch \
    libsodium curl python3 python3-dev gnupg sqlite sqlite-libs sqlite-dev readline bzip2 libev libbz2 \
    expat gdbm xz-dev libffi libffi-dev libc-dev mbedtls runit tor torsocks pwgen rng-tools \
    g++ libxslt-dev w3m c-ares zlib pcre coreutils && \
    #rsyslog logrotate util-linux findutils grep nodejs npm && \
    apk update && apk add --no-cache --virtual build-deps \
    autoconf automake build-base libev-dev libtool udns-dev libsodium-dev mbedtls-dev pcre-dev c-ares-dev \
    linux-headers curl openssl-dev zlib-dev git && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh cffi cryptography pproxy pycparser pycryptodome setuptools six obfsproxy && \
    #fteproxy
### Compile Section 1 - Files & Directories
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /go /go/bin /go/src /run/openvpn && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid && \
### Compile Section 2 - Add Groups and Users
    #addgroup -S privoxy 2>/dev/null && adduser -S -D -h /var/log/privoxy -s /sbin/nologin -G privoxy -g privoxy privoxy 2>/dev/null && \
### Compile Section 3A - Get & Configure & Make Files
    #cd /tmp && git clone -q ${PRVIVOXY_DL} && \
    #cd Privoxy-Silent && aclocal && autoheader && autoconf && ./configure --build=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu --prefix=/usr --localstatedir=/var/ --enable-zlib --enable-dynamic-pcre --with-user=privoxy --with-group=privoxy --sysconfdir=/etc/privoxy --docdir=/usr/share/doc/privoxy && make && \
    #make DESTDIR="/etc/privoxy" install && \
    #chown -R privoxy:privoxy /var/log/privoxy /etc/privoxy && \
    cd /tmp && git clone --depth=1 ${SSLIBEV_DL} && \
    cd shadowsocks-libev && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr --disable-documentation && make && \
    make install && rngd -r /dev/urandom && \
### GOLANG Section
    #cd /tmp && wget -q ${KCP_DL} && tar -xf *.gz && mv -f server_linux_amd64 kcptun && \
    #chmod u+x kcptun && mv -f /tmp/kcptun /usr/bin/kcptun && \
    #cd /tmp && git clone ${V2RAY_DL} && cd v2ray-plugin && CGO_ENABLED=0 && go build -ldflags '-w -s' -o /tmp/v2ray && \
    #upx -9 /tmp/v2ray && chmod u+x /tmp/v2ray && cp -f /tmp/v2ray /usr/bin/v2ray && \
    #cd /tmp && wget -q -O cloak ${CLOAK_DL} && chmod u+x /tmp/cloak && mv -f /tmp/cloak /usr/bin/cloak
### Clean Up all
    #rm -rf /var/cache/apk/*
    apk del build-deps

VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/var/www"]

#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8090 8080 8070
# Tor & Torsocks
EXPOSE 9050 9051
# 8118 (HTTP-Privoxy) 1080 (SOCKS5-Privoxy)
#EXPOSE 8118 1080


COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf
#COPY ./etc/privoxy/config /etc/privoxy/config

      
ADD runit /sbin/
RUN chmod a+x /sbin/runit
CMD ["/sbin/runit"]

ADD entry /sbin/
RUN chmod a+x /sbin/entry
ENTRYPOINT ["/sbin/entry"]
