#!/bin/sh

###Fronting:
# meek
# SnowFlake
###Scrambling:
# obfs4 
# ScrambleSuit (Superseded by Obfs4)
###Shapeshifting:
# Optimizer
# Dust2
# Stegotorus
# FTEproxy


go get -v git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy &
go get -v git.torproject.org/pluggable-transports/meek.git/meek-server &
 exec cp -rv /go/bin /usr/bin/

