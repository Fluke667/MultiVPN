FROM fluke667/alpine
MAINTAINER Fluke667 <Fluke667@gmail.com>  

RUN apk add --update openssl openssl-dev ca-certificates make augeas shadow openssh openvpn bash openrc nano dcron && \ 
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    touch /var/log/cron.log && \
    rm -rf /var/cache/apk/*

VOLUME ["/etc/certs"]
VOLUME ["/etc/openvpn"]

#openvpn
EXPOSE 1194


COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf
COPY ./etc/openvpn/client.conf /etc/openvpn/client.conf
COPY ./etc/openvpn/openvpn.conf /etc/openvpn/openvpn.conf



COPY ./config /config
RUN chmod 0700 /config/*.sh
RUN /config/sshd.sh \
    /config/ssl.sh \
    /config/openvpn.sh
    #/configs/sslh.sh




