FROM debian:stretch
LABEL maintainer="Fluke667 <Fluke667@gmail.com>"


RUN set -x \
         && apt-get update \
         && apt-get install --no-install-recommends --no-install-suggests -y \
         pptpd xl2tpd cron procps software-properties-common python3-pip python-setuptools python-pkg-resources python-wheel \
	 wget curl dnsutils openssl ca-certificates kmod certbot supervisor libopencv-dev libsqlite3-0 libsqlite3-dev \
         gawk grep sed git net-tools iptables gcc make pkg-config kmod libgmp-dev libssl-dev libcurl4-openssl-dev

ENV STRONGSWAN_VERSION 5.8.0

RUN mkdir -p /usr/src/strongswan \
	&& cd /usr/src \
	&& curl -SOL "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz" \
	&& tar -zxf strongswan-$STRONGSWAN_VERSION.tar.gz -C /usr/src/strongswan --strip-components 1 \
	&& cd /usr/src/strongswan \
	&& ./configure --prefix=/usr --sysconfdir=/etc \
		--enable-eap-radius \
		--enable-eap-mschapv2 \
		--enable-eap-identity \
		--enable-eap-md5 \
		--enable-eap-tls \
		--enable-eap-ttls \
		--enable-eap-peap \
		--enable-eap-tnc \
		--enable-eap-dynamic \
		--enable-xauth-eap \
                --enable-md4 \
		--enable-openssl \
                --enable-aesni \
                --enable-af-alg \
                --enable-ccm \
                --enable-curl \
                --enable-files \
                --enable-gcm \
                --enable-sqlite \
		--enable-vici \
                --enable-python-eggs \
	&& make -j \
	&& make install \
&& rm -rf "/usr/src/strongswan*" \
&& cd / \
&& git clone --depth=50 https://github.com/strongswan/strongMan.git strongMan \
&& cd strongMan \
#&& git checkout -qf ${COMMIT} \
&& pip3 install -r requirements.txt \
&& ./setup.py add-service

# PPTP Configuration
COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
# Strongswan Configuration
COPY ./etc/ipsec.conf /etc/ipsec.conf
COPY ./etc/strongswan.conf /etc/strongswan.conf
# L2TP Configuration
COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd
# Copy Scripts
COPY ./scripts/vpnadd /usr/local/bin/vpnadd
COPY ./scripts/vpndel /usr/local/bin/vpndel
COPY ./scripts/setpsk /usr/local/bin/setpsk
COPY ./scripts/unsetpsk /usr/local/bin/unsetpsk
COPY ./scripts/apply /usr/local/bin/apply

### Expose Ports
# 1723/tcp+udp - PPTP Protocol
# 500/udp  - Internet Key Exchange (IKE)
# 4500/udp - IPSec NAT Traversal
# 1701/udp - Layer 2 Forwarding Protocol (L2F) & Layer 2 Tunneling Protocol (L2TP)
# 1515/tcp - Webinterface
EXPOSE 1723/tcp 1723/udp
EXPOSE 500/udp 
EXPOSE 4500/udp
EXPOSE 1701/udp
EXPOSE 1515/tcp

COPY firewall.sh /firewall.sh
COPY auth.sh /auth.sh
COPY cert.sh /cert.sh
RUN chmod 0700 /firewall.sh
RUN chmod 0700 /auth.sh
RUN chmod 0700 /cert.sh

VOLUME ["/lib/modules"]
VOLUME ["/etc/ipsec.d"]
VOLUME ["/etc/ppp"]

CMD ["/firewall.sh"]
CMD ["/auth.sh"]
CMD ["/cert.sh"]
CMD ["pptpd", "--fg"]
