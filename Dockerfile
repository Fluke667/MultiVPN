FROM debian:stretch
LABEL maintainer="Fluke667 <Fluke667@gmail.com>"


RUN set -x \
         && apt-get update \
         && apt-get install --no-install-recommends --no-install-suggests -y \
         pptpd xl2tpd cron procps software-properties-common \
         #strongswan libstrongswan-extra-plugins \
         wget dnsutils openssl ca-certificates kmod certbot \
         gawk grep sed net-tools iptables gcc make pkg-config 

ENV STRONGSWAN_VERSION 5.8.0
ENV GPG_KEY 948F158A4E76A27BF3D07532DF42C170B34DBA77

RUN mkdir -p /usr/src/strongswan \
	&& cd /usr/src \
	&& curl -SOL "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz.sig" \
	&& curl -SOL "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify strongswan-$STRONGSWAN_VERSION.tar.gz.sig strongswan-$STRONGSWAN_VERSION.tar.gz \
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
		--enable-eap-dynamic \\
		--enable-xauth-eap \
                  --enable-md4 \
		--enable-openssl \
                  --enable-aesni \
                  --enable-af-alg \
                  --enable-ccm \
                  --enable-curl \
                  --enable-files \
                  --enable-gcm \
                  --enable-sql \
	         --enable-mysql \
	         --enable-attr-sql \
	&& make -j \
	&& make install \
&& rm -rf "/usr/src/strongswan*"

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ipsec.conf /etc/ipsec.conf
COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./etc/ppp/chap-secrets /etc/ppp/chap-secrets


EXPOSE 1723/tcp 500/udp 4500/udp 1701/udp


COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

VOLUME ["/lib/modules"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
