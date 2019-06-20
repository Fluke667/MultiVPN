# MultVPN a PPTP / L2TP Server

docker run --name pptpd --privileged -d -p 1723:1723 -v /data/ppp:/etc/ppp/chap-secrets fluke667/multvpn
