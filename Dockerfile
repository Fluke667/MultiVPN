FROM fluke667/alpine
MAINTAINER Fluke667 <Fluke667@gmail.com>

RUN apk add --update --no-cache alpine-baselayout alpine-conf alpine-base busybox openrc musl musl-dev linux-headers \
    openssl openssl-dev ca-certificates make augeas shadow openssh openvpn bash nano sudo dcron build-base git \
    libsodium libsodium-dev curl python3 python3-dev gnupg sqlite sqlite-libs sqlite-dev readline bzip2 libbz2 \
    expat gdbm xz-dev libffi libffi-dev runit tor torsocks pwgen && \
    #rsyslog logrotate util-linux coreutils findutils grep && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    mkdir /etc/container_environment && \
    touch /var/log/cron.log   && \
    rm -rf /var/cache/apk/* && \
    pip3 install --upgrade pip && \
    pip3 install asn1crypto asyncssh cffi cryptography pproxy pycparser pycryptodome setuptools six


VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]

# openvpn  # python-proxy # Tor
EXPOSE 1194 8090 8080 8070 9050
#python-proxy
#EXPOSE 8090 8080 8070

COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

ADD runit /sbin/
RUN chmod a+x /sbin/runit

#COPY ./config /config
#RUN chmod 0700 /config/*.sh




CMD ["/sbin/runit"]
