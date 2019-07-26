FROM fluke667/alpine
MAINTAINER Fluke667 <Fluke667@gmail.com>

RUN apk add --update --no-cache alpine-baselayout alpine-conf alpine-base busybox openrc musl musl-dev linux-headers \
    openssl openssl-dev ca-certificates make shadow openssh openvpn bash nano go sudo dcron build-base git upx \
    libsodium libsodium-dev curl python3 python3-dev gnupg sqlite sqlite-libs sqlite-dev readline bzip2 libbz2 \
    expat gdbm xz-dev libffi libffi-dev libc-dev runit tor torsocks pwgen shadowsocks-libev nodejs npm \
    g++ libxslt-dev && \
    #rsyslog logrotate util-linux coreutils findutils grep && \
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/container_environment /go /go/bin /go/src /run/openvpn && \
    chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log  /run/openvpn/ovpn.pid && \
    rm -rf /var/cache/apk/* && \
### PYTHON SECTION
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh cffi cryptography pproxy pycparser pycryptodome setuptools six obfsproxy && \
    #fteproxy
### GOLANG Section
    cd /tmp && wget -q ${KCP_DL} && tar -xf *.gz && mv -f server_linux_amd64 kcptun && \
    chmod u+x kcptun && mv -f /tmp/kcptun /usr/bin/kcptun && \
    
    cd /tmp && git clone ${V2RAY_DL} && cd v2ray-plugin && CGO_ENABLED=0 && go build -ldflags '-w -s' -o /tmp/v2ray && \
    upx -9 /tmp/v2ray && chmod u+x /tmp/v2ray && cp -f /tmp/v2ray /usr/bin/v2ray && \
    
    cd /tmp && wget -q -O cloak ${CLOAK_DL} && chmod u+x /tmp/cloak && mv -f /tmp/cloak /usr/bin/cloak


VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]
VOLUME ["/var/www"]

#openvpn
EXPOSE 1194
# python-proxy
EXPOSE 8090 8080 8070
# Tor & Torsocks
EXPOSE 9050



COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

      
      
ADD runit /sbin/
RUN chmod a+x /sbin/runit
CMD ["/sbin/runit"]

ADD entry /sbin/
RUN chmod a+x /sbin/entry
ENTRYPOINT ["/sbin/entry"]
