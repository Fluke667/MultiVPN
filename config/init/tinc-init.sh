#!/bin/sh

		#Generate Certificate
		tinc -n $TINC_NETNAME generate-keys 2048 < /dev/null
		
		#Add Interface
                ip tuntap add dev $TINC_INTERFACE mode tun
                ip link set $TINC_INTERFACE up
                ip addr add 10.0.0.2/32 dev $TINC_INTERFACE
		
		
"$@"
