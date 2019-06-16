FROM debian:stretch
LABEL maintainer="Fluke667 <Fluke667@gmail.com>"


RUN apt-get update && apt-get install -y ppp pptpd iptables strongswan xl2tpd cron procps net-tools

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./etc/ppp/chap-secrets /etc/ppp/chap-secrets

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
