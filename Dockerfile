FROM alpine:3.9
MAINTAINER Fluke667 <Fluke667@gmail.com>  
ARG TZ='Europe/Berlin'
ENV TZ ${TZ}

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
            openssl-dev \
	    strongswan && \
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


CMD ["start", "--nofork"]
ENTRYPOINT ["/usr/sbin/ipsec"]

