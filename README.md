# MultVPN a PPTP / L2TP Server


Start the IPsec VPN server
VERY IMPORTANT ! First, run this command on the Docker host to load the IPsec NETKEY kernel module:


sudo modprobe af_key


```
docker run \
    --name multivpn \
    -p 1723:1723 \
    -p 1515:1515 \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -p 1701:1701/udp \
    -v /data/ppp:/etc/ppp \
    -v /lib/modules:/lib/modules \
    -d --privileged \
    -e VPN_USER=MyUsername VPN_PASSWORD=MyPassword \
    -e VPN_PSK=MyPSK \
    -e CRT_COUNTRY=DE CRT_STATE=Bavaria CRT_LOC=Nuremberg CRT_NAME=TB CRT_ORG=ORG CRT_DOM=localhost \
    fluke667/multvpn
```

##The fields, specified in second certificate line are listed below:

CRT_COUNTRY= - Country name. The two-letter ISO abbreviation.
CRT_STATE= - State or Province name.
CRT_LOC= - Locality Name. The name of the city where you are located.
CRT_NAME= - The full name of your organization.
CRT_ORG= - Organizational Unit.
CRT_DOM= - The fully qualified domain name ##
