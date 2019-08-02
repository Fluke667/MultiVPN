#!/bin/sh
                #Create Folders
                mkdir -p /etc/tinc
                mkdir -p /etc/tinc/$TINC_NETWORK/
                mkdir -p /etc/tinc/$TINC_NETWORK/hosts
		
		# Declare public and private IPs in the host file, CONFIG/NET/hosts/HOST
		echo "Address = "$TINC_PUB_IP >> /etc/tinc/$TINC_NETWORK/hosts/TINC_$NODE
		echo "Subnet = "$TINC_PRIV_IP"/32" >> /etc/tinc/$TINC_NETWORK/hosts/$TINC_NODE
		echo "Cipher = id-aes256-GCM" >> /etc/tinc/$TINC_NETWORK/hosts/$TINC_NODE
		echo "Digest = whirlpool" >> /etc/tinc/$TINC_NETWORK/hosts/$TINC_NODE
		echo "MACLength = 16" >> /etc/tinc/$TINC_NETWORK/hosts/$TINC_NODE
		echo "Compression = "$TINC_COMPRESSION >> /etc/tinc/$TINC_NETWORK/hosts/$TINC_NODE

		# Set Runtime Configuration for Tinc
		echo "Name = "$TINC_NODE > /etc/tinc/$TINC_NETWORK/tinc.conf
		echo "AddressFamily = ipv4" >> /etc/tinc/$TINC_NETWORK/tinc.conf
		echo "Device = /dev/net/tun"  >> /etc/tinc/$TINC_NETWORK/tinc.conf
		echo "Interface = "$TINC_INTERFACE  >> /etc/tinc/$TINC_NETWORK/tinc.conf

		# Edit the tinc-up script
		echo '#!/bin/sh' >/etc/tinc/$TINC_NETWORK/tinc-up
		echo 'ifconfig '$TINC_INTERFACE $TINC_PRIV_IP' netmask 255.255.255.0' >> /etc/tinc/$TINC_NETWORK/tinc-up
		echo '#!/bin/sh' > /etc/tinc/$TINC_NETWORK/tinc-down
		echo 'ifconfig '$TINC_INTERFACE' down' >> /etc/tinc/$TINC_NETWORK/tinc-down
		chmod +x /etc/tinc/$TINC_NETWORK/tinc-up
		chmod +x /etc/tinc/$TINC_NETWORK/tinc-down

               
$@
