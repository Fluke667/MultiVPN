FROM fluke667/alpine
MAINTAINER Fluke667 <Fluke667@gmail.com>  

RUN apk add --update openssl make augeas shadow openssh openvpn bash openrc && \ 
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    rm -rf /var/cache/apk/*

VOLUME ["/etc/certs/ssl"]

EXPOSE 1194
EXPOSE 22

COPY ./etc/ssl/issuer.ext /etc/ssl/issuer.ext
COPY ./etc/ssl/public.ext /etc/ssl/public.ext
COPY ./etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config
COPY ./etc/openvpn/vpnconf /etc/openvpn/vpnconf
COPY ./etc/openvpn/client.conf /etc/openvpn/client.conf
COPY ./etc/openvpn/server.conf /etc/openvpn/server.conf
COPY ./config /config
RUN chmod 0700 /config/*.sh
RUN /config/sshd.sh \
    /config/ssl.sh
    #/configs/sslh.sh \
    #/config/openvpn.sh
    
