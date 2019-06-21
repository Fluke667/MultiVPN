# MultVPN a PPTP / L2TP Server


Start the IPsec VPN server
VERY IMPORTANT ! First, run this command on the Docker host to load the IPsec NETKEY kernel module:


sudo modprobe af_key


```
docker run \
    --name multivpn \
    -p 1723:1723/udp 1515:1515/tcp 500:500/udp 4500:4500/udp 1701:1701/udp \
    -v /data/ppp:/etc/ppp \
    -v /lib/modules:/lib/modules \
    -d --privileged \
    -e VPN_USER=MyUsername VPN_PASSWORD=MyPassword \
    -e VPN_PSK=MyPSK \
    -e VPN_DNS1=1.1.1.1 VPN_DNS2=1.0.0.1 \
    -e CRT_CN=DE CRT_ST=Bavaria CRT_LOC=Nuremberg CRT_NAME=TB CRT_ORG=ORG CRT_DOM=localhost \
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
vpnadd <user> <pass>
vpndel <user>
setpsk <psk>
unsetpsk <psk>
apply
```
