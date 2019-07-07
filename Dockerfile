FROM alpine:3.10
MAINTAINER Fluke667 <Fluke667@gmail.com>  
ARG TZ='Europe/Berlin'
USER root
WORKDIR /root
CMD alias python=python3

RUN wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub && \
    echo "https://alpine-repo.sourceforge.io/packages" >> /etc/apk/repositories
    #echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories
    
RUN apk update && apk add --no-cache --virtual build-dependencies \
    libev-dev libsodium-dev mbedtls-dev pcre-dev iptables-dev sqlite-dev musl-dev boost-dev gmp-dev libressl-dev tzdata \
    openssl-dev curl-dev python3-dev libtool c-ares-dev zlib-dev libffi-dev libconfig-dev libevent-dev zstd-dev xz-dev \
    build-base gcc g++ git autoconf automake cmake make wget curl w3m
    
RUN apk update && apk add --no-cache \
    linux-headers bash rng-tools shadow gnupg runit nano go tar tor torsocks openvpn openvpn-auth-pam python3 libffi \ 
    strongswan ca-certificates iptables iproute2 pptpd xl2tpd sqlite sqlite-libs openssl openssh easy-rsa nodejs npm \
    readline libsodium libconfig bzip2 libbz2 zstd expat gdbm xz xz-libs zlib libevent dcron stunnel gnupg libressl \
    obfs4proxy meek simple-obfs pwgen boost-filesystem boost-program_options boost-date_time libssl1.1 websocket++ \
    miniupnpc libstdc++ ethtool
    
RUN pip3 install --no-cache --upgrade \
    asn1crypto asyncssh pycparser pycryptodome pproxy six
    #fteproxy
### Compile Section - Touch Files and Directories
RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && mkdir -m 0644 -p /etc/cron.d && mkdir -p /tmp/build \
    mkdir -p /home/i2pd /home/i2pd/data && \
    touch /var/log/cron/cron.log
### Compile Section - Add Groups and Users
RUN groupadd -g 2100 i2pd && useradd -u 1100 --create-home --home-dir /home/i2pd -g i2pd i2pd 
    #groupadd -g 2000 privoxy && useradd -m -u 2001 -g privoxy privoxy
### Compile Section - Get & Configure & Make Files
RUN cd /tmp/build && git clone -q ${PRVIVOXY_DL} && \
    cd Privoxy-Silent && \
    autoheader && autoconf && ./configure && make && \
    make -n install USER=privoxy GROUP=privoxy
RUN cd /tmp/build && git clone -q ${PURPLEI2P_DL} && \
    cd i2pd/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/home/i2pd -DCMAKE_BUILD_TYPE=Release -DWITH_LIBRARY=OFF -DWITH_PCH=OFF -DWITH_AESNI=ON -DWITH_HARDENING=ON && \
    make -j$(nproc) && make install && \
    chown i2pd:i2pd -R /home/i2pd
RUN echo "**** install Python ****" && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi


### Expose Ports
# sslh Multiplexer
EXPOSE 443
# 1723 (PPTP) 500 (IKE) 4500 (IPSec NAT Traversal) 1701 (L2F) & (L2TP)
#EXPOSE 1723/tcp 1723/udp 500/udp 4500/udp 1701/udp
# 8010/tcp 8020/tcp 8030/tcp 8040/tcp - Ports for pproxy
#EXPOSE 8010/tcp 8020/tcp 8030/tcp 8040/tcp
# 9001 9030 9050 54444 9443 7002 - ORPort, DirPort, SocksPort, Obfsproxy, Obfs4Proxy MeekPort
#EXPOSE 9001 9030 9050 54444 7002
# 8388/8377/8366 (shadowsocks-libev) 9443 (kcptun) 
#EXPOSE 8388/tcp 8388/udp 8377/tcp 8377/udp 8366/tcp 8366/udp 9443/udp
# 1194 (Openvpn)
EXPOSE 1194/udp
# 8118 (Privoxy) 1080 (Privoxy-Socks)
#EXPOSE 8118/tcp 1080/tcp
# 1515 (Webinterface) 443 (sslh)
#EXPOSE 1515/tcp


# PPTP Configuration
COPY ./etc/pptpd.conf /etc/pptpd.conf   
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options  
# Strongswan Configuration  
COPY ./etc/ipsec.conf /etc/ipsec.conf   
COPY ./etc/strongswan.conf /etc/strongswan.conf 
COPY ./etc/strongswan.d/charon.conf /etc/strongswan.d/charon.conf
# L2TP Configuration  
COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd 
# TOR  Configuration
COPY ./etc/tor/torrc /etc/tor/torrc
# Privoxy Configuration
COPY ./etc/privoxy/config /etc/privoxy/config
# Copy Scripts 
COPY ./scripts/* /usr/local/bin/
RUN chmod 0700 /usr/local/bin/*



VOLUME /etc/ppp \
       /etc/ipsec.d \
       /etc/stunnel \
       /etc/strongswan.d \
       /etc/xl2tpd \
       /etc/periodic \
       /etc/tor \
       /etc/ssl/certs \
       /usr/share/easy-rsa \
       /etc/openvpn 
       
#VOLUME ["/data/openvpn", "/data/easyrsa"]



RUN rm -rf /tmp/* \
    rm -rf /var/cache/apk/* \
     /var/tmp/* \
     apk del build-dependencies

ADD ./config /config
RUN chmod 0700 /config/*.sh
RUN /config/tz.sh \
    /config/auth.sh \
    /config/cert.sh \
    /config/firewall.sh \
    /config/pproxy.sh \
    /config/sslh.sh \
    /config/stunnel.sh \
    /config/tor.sh \
    /config/shadowsocks.sh \
    /config/shadowsocks-kcptun.sh \
    /config/shadowsocks-plugin.sh \
    /config/openvpn.sh \
    /config/privoxy.sh

COPY entrypoint.sh /
RUN chmod u+x /entrypoint.sh
RUN ["/entrypoint.sh"]

CMD ["/bin/bash"]  
