FROM alpine:3.9
MAINTAINER Fluke667 <Fluke667@gmail.com>  
ARG TZ='Europe/Berlin'

RUN wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
RUN echo "https://alpine-repo.sourceforge.io/packages" >> /etc/apk/repositories

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
    libev-dev libsodium-dev mbedtls-dev pcre-dev iptables-dev sqlite-dev musl-dev xz-dev gmp-dev libressl-dev \
    openssl-dev curl-dev python3-dev libtool c-ares-dev zlib-dev libffi-dev libconfig-dev libevent-dev zstd-dev \
    build-base gcc g++ git autoconf automake make wget linux-headers
    
RUN apk update \
    && apk add --no-cache \
        sudo \
        bash \
	tzdata \
	rng-tools \
	gnupg \
	runit \
        curl \
	nano \
	go \
        libtool \
        tar \
	tor torsocks \
	privoxy \
	#socat \
	python3 \
	libffi \
	nodejs npm \
        ca-certificates \
        iptables ip6tables iproute2 \
	pptpd \
	xl2tpd \
	sqlite sqlite-libs \
        openssl \
	openssh \
        strongswan \
	libsodium \
	libconfig \
	bzip2 \
	libbz2 \
	zstd \
	expat \
	gdbm \
	xz xz-libs \
	zlib \
	libevent \
	dcron \
	stunnel \
	gnupg \
	libressl \
	readline \
	obfs4proxy \
	meek \
	pwgen

    
RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d
    
RUN apk update --no-cache --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ \
      apk add --no-cache sslh i2pd

    
    
    #python3 -m ensurepip && \
    #rm -r /usr/lib/python*/ensurepip && \
    #pip3 install --upgrade pip && \
    #if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    #if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    #rm -r /root/.cache && \
    
RUN pip install --upgrade pip \
    pip install --no-cache --upgrade \
    asn1crypto asyncssh pycparser pycryptodome pproxy obfsproxy cffi six setuptools fteproxy
    #wheel 
    



### Expose Ports
# 1723/tcp+udp - PPTP Protocol    
# 500/udp  - Internet Key Exchange (IKE)   
# 4500/udp - IPSec NAT Traversal
# 1701/udp - Layer 2 Forwarding Protocol (L2F) & Layer 2 Tunneling Protocol (L2TP)
# 1515/tcp - Webinterface
# 8388/tcp 8388/udp - shadowsocks-libev Ports
# 8118/tcp - Privoxy Port
# 8010/tcp 8020/tcp 8030/tcp 8040/tcp - Ports for pproxy
# 9001 9030 9050 54444 9443 7002 - ORPort, DirPort, SocksPort, Obfsproxy, Obfs4Proxy MeekPort
EXPOSE 1723/tcp 1723/udp 500/udp 4500/udp 1701/udp 1515/tcp 8388/tcp 8388/udp 8118/tcp 8010/tcp 8020/tcp 8030/tcp 8040/tcp
EXPOSE 9001 9030 9050 54444 9443 7002


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
# Copy Scripts 
COPY ./scripts/* /usr/local/bin/

#RUN sudo addgroup -g 19001 -S tor && sudo adduser -D -u 19001 -G tor -S tor
#RUN sudo addgroup -g 19001 -S $TOR_USER && sudo adduser -D -u 19001 -G $TOR_USER -S $TOR_USER

# /data/multivpn/ppp
# /data/multivpn/ipsec.d
# /data/multivpn/stunnel
# /data/multivpn/strongswan.d
# /data/multivpn/xl2tpd
# /data/multivpn/crond
# /data/multivpn/tor
# /data/multivpn/lib
#VOLUME ["/etc/ppp"]
#VOLUME ["/etc/ipsec.d"]
#VOLUME ["/etc/stunnel"]
#VOLUME ["/etc/strongswan.d"]
#VOLUME ["/etc/xl2tpd"]
#VOLUME ["/etc/periodic"]
#VOLUME ["/var/lib/tor"]
#VOLUME ["/etc/tor"]


VOLUME /etc/ppp \
       /etc/ipsec.d \
       /etc/stunnel \
       /etc/strongswan.d \
       /etc/xl2tpd \
       /etc/periodic \
       /etc/tor
       



RUN rm -rf /tmp/* \
    rm -rf /var/cache/apk/* \
     /var/tmp/*

ADD ./config /config
RUN chmod 0700 /config/*.sh
RUN /config/tz.sh \
    /config/auth.sh \
    /config/cert.sh \
    /config/firewall.sh \
    /config/pproxy.sh \
    /config/sslh.sh \
    /config/stunnel.sh \
    /config/tor.sh

#CMD ["start", "--nofork"]
ENTRYPOINT ["/entrypoint.sh"]

