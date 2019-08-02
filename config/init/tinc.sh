#!/bin/sh
                #Create Folders
                mkdir -p /etc/tinc/
                mkdir -p /etc/tinc/hosts/
                mkdir -p /var/log/tinc/


                # Declare public and private IPs in the host file, CONFIG/NET/hosts/HOST
                echo "Address = "$TINC_PUB_IP >> /etc/tinc/hosts/TINC_$NODE
                echo "Subnet = "$TINC_PRIV_IP"/32" >> /etc/tinc/hosts/$TINC_NODE
                echo "Cipher = id-aes256-GCM" >> /etc/tinc/hosts/$TINC_NODE
                echo "Digest = whirlpool" >> /etc/tinc/hosts/$TINC_NODE
                echo "MACLength = 16" >> /etc/tinc/hosts/$TINC_NODE
                echo "Compression = "$TINC_COMPRESSION >> /etc/tinc/hosts/$TINC_NODE

                # Set Runtime Configuration for Tinc
                echo "Name = "$TINC_NODE > /etc/tinc/tinc.conf
                echo "AddressFamily = ipv4" >> /etc/tinc/tinc.conf
                echo "Device = /dev/net/tun"  >> /etc/tinc/tinc.conf
                echo "Interface = "$TINC_INTERFACE  >> /etc/tinc/tinc.conf

                # Edit the tinc-up script
                echo '#!/bin/sh' >/etc/tinc/tinc-up
                echo 'ifconfig '$TINC_INTERFACE $TINC_PRIV_IP' netmask 255.255.255.0' >> /etc/tinc/tinc-up
                echo '#!/bin/sh' > /etc/tinc/tinc-down
                echo 'ifconfig '$TINC_INTERFACE' down' >> /etc/tinc/tinc-down
                chmod +x /etc/tinc/tinc-up
                chmod +x /etc/tinc/tinc-down

		
		#Generate Certificate
                tincd --generate-keys=2048
               
$@
