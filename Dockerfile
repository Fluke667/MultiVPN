FROM alpine:3.9
ENV STRONGSWAN_RELEASE https://download.strongswan.org/strongswan.tar.bz2

RUN apk --update add build-base \
            ca-certificates \
            curl \
            curl-dev \
            ip6tables \
            iproute2 \
            iptables-dev \
	    pptpd \
	    xl2tpd \
	    sqlite \
	    sqlite-libs \
	    sqlite-dev \
            openssl \
            openssl-dev && \
    mkdir -p /tmp/strongswan && \
    curl -Lo /tmp/strongswan.tar.bz2 $STRONGSWAN_RELEASE && \
    tar --strip-components=1 -C /tmp/strongswan -xjf /tmp/strongswan.tar.bz2 && \
    cd /tmp/strongswan && \
    ./configure --prefix=/usr \
            --sysconfdir=/etc \
            --libexecdir=/usr/lib \
            --with-ipsecdir=/usr/lib/strongswan \
            --enable-aesni \
            --enable-chapoly \
            --enable-cmd \
            --enable-curl \
            --enable-dhcp \
            --enable-eap-dynamic \
            --enable-eap-identity \
            --enable-eap-md5 \
            --enable-eap-mschapv2 \
            --enable-eap-radius \
            --enable-eap-tls \
            --enable-eap-ttls \
            --enable-eap-tnc \
            --enable-eap-peap \
            --enable-farp \
            --enable-files \
            --enable-gcm \
            --enable-md4 \
            --enable-newhope \
            --enable-ntru \
            --enable-openssl \
            --enable-sha3 \
            --enable-shared \
            --enable-xauth-eap \
            --enable-md4 \
            --enable-af-alg \
            --enable-ccm \
            #--enable-sqlite
	    --enable-vici \
            --enable-python-eggs \
            --disable-aes \
            --disable-des \
            --disable-gmp \
            --disable-hmac \
            --disable-ikev1 \
            --disable-md5 \
            --disable-rc2 \
            --disable-sha1 \
            --disable-sha2 \
            --disable-static && \
    make && \
    make install && \
    rm -rf /tmp/* && \
    apk del build-base curl-dev openssl-dev && \
    rm -rf /var/cache/apk/*

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
      
      
        


ENTRYPOINT ["/usr/sbin/ipsec"]
CMD ["start", "--nofork"]
