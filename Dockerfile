FROM debian:stretch
LABEL maintainer="Fluke667 <Fluke667@gmail.com>"


RUN apt-get update \
apt-get -yqq --no-install-recommends install \
         ppp pptpd xl2tpd cron procps strongswan \
         wget dnsutils openssl ca-certificates kmod \
         iproute gawk grep sed net-tools iptables \
         bsdmainutils libcurl3-nss \
         libnss3-tools libevent-dev libcap-ng0 \
         libnss3-dev libnspr4-dev pkg-config libpam0g-dev \
         libcap-ng-dev libcap-ng-utils libselinux1-dev \
         libcurl4-nss-dev libpcap0.8-dev \
flex bison gcc make



COPY ./etc/pptpd.conf /etc/pptpd.conf
#COPY ./etc/ipsec.conf /etc/pptpd.conf
#COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
#COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./etc/ppp/chap-secrets /etc/ppp/chap-secrets


COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
