# MultiVPN
Protocols: PPTP, L2TP, Ikev2, Shadowsocks, OpenVPN, 


### Before Start Container:
- modprobe af_key
- modprobe nf_nat_pptp
- modprobe tun
- modprobe ppp_mppe
- modprobe ah4
- modprobe ah6
- modprobe esp4
- modprobe esp6
- modprobe xfrm4_tunnel
- modprobe xfrm6_tunnel
- modprobe xfrm_user
- modprobe ip_tunnel
- modprobe tunnel4
- modprobe tunnel6
- modprobe xfrm4_mode_tunnel
- modprobe xfrm6_mode_tunnel
- modprobe pcrypt
- modprobe xfrm_ipcomp
- modprobe deflate


```
docker run \
    --name multivpn \
    --env-file ./vpn.env \
    -p 1723:1723/udp \
    -p 1515:1515/tcp \ 
    -p 500:500/udp \
    -p 4500:4500/udp \ 
    -p 1701:1701/udp \
    -v /data/ppp:/etc/ppp \
    -v /lib/modules:/lib/modules \
    -v /etc/ipsec.d:/etc/ipsec.d \
    -d --privileged \
    -e VPN_USER=MyUsername VPN_PASSWORD=MyPassword VPN_PSK=MyPSK \
    -e VPN_DNS1=1.1.1.1 VPN_DNS2=1.0.0.1 \
    -e CRT_CN=DE CRT_ST=Bavaria CRT_LOC=Berlin CRT_NAME=TB CRT_ORG=ORG CRT_DOM=localhost CRT_P12=CertPass \
    fluke667/multvpn
    
    
```


### Exposed Ports
- 1723/tcp+udp - PPTP Protocol  
- 500/udp  - Internet Key Exchange (IKE)   
- 4500/udp - IPSec NAT Traversal   
- 1701/udp - Layer 2 Forwarding Protocol (L2F) & Layer 2 Tunneling Protocol (L2TP)    
- 1515/tcp - Webinterface


### The fields, specified in certificate line are listed below:
- CRT_CN= - Country name. The two-letter ISO abbreviation.
- CRT_ST= - State or Province name.
- CRT_LOC= - Locality Name. The name of the city where you are located.
- CRT_NAME= - The full name of your organization.
- CRT_ORG= - Organizational Unit.
- CRT_DOM= - The fully qualified domain name.

### Script Commands
```
| Command                   | Description                                                       |
|---------------------------+-------------------------------------------------------------------|
| vpnadd <user> <pass>      |                                                                   |      
| vpndel <user>             |                                                                   | 
| setpsk <psk>              |                                                                   | 
| unsetpsk <psk>            |                                                                   | 
| apply                     |                                                                   | 
| mods-check                |                                                                   | 
| mods-enable               |                                                                   |
| easyrsa help              |                                                                   | 
|---------------------------+-------------------------------------------------------------------|
```

### Services

Protocols: PPTP, L2TP, Ikev2, Shadowsocks, OpenVPN,


Shadowsocks Plugin Options:
#### Shadowsocks over websocket (HTTP)
plugin v2ray-plugin plugin-opts "server"

#### Shadowsocks over websocket (HTTPS)
plugin v2ray-plugin plugin-opts "server;tls;host=mydomain.me"

#### Shadowsocks over Quic
plugin v2ray-plugin plugin-opts "server;mode=quic;host=mydomain.me"



# Service                 Software           Port         Transport      Proto
# -----------------------|------------------|------------|--------------|------------|
# eepSite proxy                              4446
# [socksproxy]                               4447
# [bob]                                      2827
# [sam]                                      7656
# [i2pcontrol]                               7650
#
#
#
#
#
#
#
#
#
#
#
#
