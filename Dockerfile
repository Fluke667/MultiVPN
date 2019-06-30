FROM alpine:3.9
MAINTAINER Fluke667 <Fluke667@gmail.com>  
ARG TZ='Europe/Berlin'
ENV TZ ${TZ}

RUN wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
RUN apk add --no-cache -X https://alpine-repo.sourceforge.io/packages

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
    libev-dev libsodium-dev mbedtls-dev pcre-dev iptables-dev libconfig-dev sqlite-dev musl-dev \
    openssl-dev curl-dev python3-dev libtool c-ares-dev zlib-dev \
    build-base gcc g++ git autoconf automake make wget linux-headers
	
RUN apk upgrade \
    && apk add --no-cache \
        bash \
	tzdata \
	rng-tools \
	runit \
        curl \
	nano \
	go \
        libtool \
        tar \
	python3 \
	nodejs npm \
        ca-certificates \
        iptables ip6tables iproute2 \
	pptpd \
	xl2tpd \
	sqlite sqlite-libs \
        openssl \
        strongswan \
	libconfig \
	stunnel \
	gnupg \
	libressl \
    rm -rf /tmp/* \
    rm -rf /var/cache/apk/*
    
RUN apk --update --no-cache --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ \
      && apk add --no-cache sslh \
      rm -rf /var/cache/apk/* \
      /tmp/* \
     /var/tmp/*
    
    COPY config.sh /config.sh 
    RUN chmod 0700 /config.sh
    CMD ["./config.sh"]
    
    RUN python3 -m ensurepip \
    pip3 install --no-cache --upgrade pip setuptools wheel


### Expose Ports
# 1723/tcp+udp - PPTP Protocol    
# 500/udp  - Internet Key Exchange (IKE)   
# 4500/udp - IPSec NAT Traversal
# 1701/udp - Layer 2 Forwarding Protocol (L2F) & Layer 2 Tunneling Protocol (L2TP)
# 1515/tcp - Webinterface
EXPOSE 1723/tcp 1723/udp 500/udp 4500/udp 1701/udp 1515/tcp


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
# Copy Scripts 
COPY ./scripts/vpnadd /usr/local/bin/vpnadd 
COPY ./scripts/vpndel /usr/local/bin/vpndel 
COPY ./scripts/setpsk /usr/local/bin/setpsk 
COPY ./scripts/unsetpsk /usr/local/bin/unsetpsk  
COPY ./scripts/apply /usr/local/bin/apply  
COPY ./scripts/mods-check /usr/local/bin/mods-check  
COPY ./scripts/mods-enable /usr/local/bin/mods-enable
      
### Install Firewall/Iptables Rules
COPY firewall.sh /firewall.sh
RUN chmod 0700 /firewall.sh
CMD ["/firewall.sh"]
### Install Auth Files
COPY auth.sh /auth.sh
RUN chmod 0700 /auth.sh
CMD ["/auth.sh"]
### Generate Certificate
COPY cert.sh /cert.sh
RUN chmod 0700 /cert.sh
CMD ["/cert.sh"]

RUN apk del build-dependencies

CMD ["start", "--nofork"]
ENTRYPOINT ["/usr/sbin/ipsec"]

