FROM debian:stretch
LABEL maintainer="Fluke667 <Fluke667@gmail.com>"


RUN set -x \
         && apt-get update \
         && apt-get install --no-install-recommends --no-install-suggests -y \
         pptpd xl2tpd cron procps software-properties-common \
         strongswan libstrongswan-extra-plugins \
         wget dnsutils openssl ca-certificates kmod certbot \
         gawk grep sed net-tools iptables gcc make pkg-config 


COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ipsec.conf /etc/ipsec.conf
COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./etc/ppp/chap-secrets /etc/ppp/chap-secrets


EXPOSE 1723/tcp 500/udp 4500/udp


COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

VOLUME ["/lib/modules"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
