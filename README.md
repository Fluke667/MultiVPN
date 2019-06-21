# MultVPN a PPTP / L2TP Server


docker run \
    --name multivpn \
    -p 1723:1723 \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /data/ppp:/etc/ppp \
    -v /lib/modules:/lib/modules \
    -d --privileged \
    fluke667/multvpn
