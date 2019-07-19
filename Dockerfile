FROM fluke667/alpine
MAINTAINER Fluke667 <Fluke667@gmail.com>
CMD alias python=python3

#RUN apk add --update --no-cache --virtual build-dependencies \
#    libffi-dev musl-dev openssl-dev gcc g++ build-base git libsodium-dev xz-dev python3-dev
#RUN apk add --update --no-cache openssl ca-certificates make augeas shadow openssh openvpn bash libsodium \
#    openrc nano dcron gmp libffi musl gnupg readline bzip2 libbz2 expat gdbm xz && \
    #py3-pycryptodome py3-cryptography && \ 
RUN apk add --update --no-cache openssl openssl-dev ca-certificates make augeas shadow openssh openvpn bash \
    openrc nano dcron && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log && \
    rm -rf /var/cache/apk/*
RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    pip3 install --no-cache --upgrade asn1crypto pproxy[accelerated] asyncio pycryptodome six
    #cryptography cffi asyncssh
    #pip3 list

VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]

#openvpn
EXPOSE 1194
#python-proxy
EXPOSE 8090 
#8080 8070 8060

COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf

COPY ./config /config
RUN chmod 0700 /config/*.sh
RUN /config/sshd.sh \
    /config/ssl.sh \
    /config/openvpn.sh \
    /config/pproxy.sh
    #/configs/sslh.sh




