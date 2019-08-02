#!/bin/sh
                #Create Folders
                mkdir -p /etc/tinc/
		mkdir -p /etc/tinc/$TINC_NETNAME
                mkdir -p /etc/tinc/$TINC_NETNAME/hosts
                mkdir -p /var/log/tinc/

                # Declare public and private IPs in the host file, CONFIG/NET/hosts/HOST
                echo "Address = "$TINC_PUB_IP >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                echo "Subnet = "$TINC_PRIV_IP"/32" >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                echo "Cipher = id-aes256-GCM" >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                echo "Digest = whirlpool" >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                echo "MACLength = 16" >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                echo "Compression = "$TINC_COMPRESSION >> /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
                chmod 644 /etc/tinc/$TINC_NETNAME/hosts/$TINC_NODE
		
                # Set Runtime Configuration for Tinc
                echo "Name = "$TINC_NODE > /etc/tinc/$TINC_NETNAME/tinc.conf
                echo "AddressFamily = ipv4" >> /etc/tinc/$TINC_NETNAME/tinc.conf
                echo "Device = /dev/net/tun"  >> /etc/tinc/$TINC_NETNAME/tinc.conf
                echo "Interface = "$TINC_INTERFACE  >> /etc/tinc/$TINC_NETNAME/tinc.conf
		echo "PrivateKeyFile = /etc/tinc/rsa_key.priv" >> /etc/tinc/$TINC_NETNAME/tinc.conf
                echo "#Mode = switch" >> /etc/tinc/$TINC_NETNAME/tinc.conf
                echo "#ConnectTo = <other.client>" >> /etc/tinc/$TINC_NETNAME/tinc.conf     
                echo "#ProcessPriority = high" >> /etc/tinc/$TINC_NETNAME/tinc.conf 
                echo "#LocalDiscovery = yes" >> /etc/tinc/$TINC_NETNAME/tinc.conf 

                # Edit the tinc-up script
                echo '#!/bin/sh' >/etc/tinc/$TINC_NETNAME/tinc-up
                echo 'ifconfig '$TINC_INTERFACE $TINC_PRIV_IP' netmask 255.255.255.0' >> /etc/tinc/$TINC_NETNAME/tinc-up
                echo '#!/bin/sh' > /etc/tinc/$TINC_NETNAME/tinc-down
                echo 'ifconfig '$TINC_INTERFACE' down' >> /etc/tinc/$TINC_NETNAME/tinc-down
                chmod +x /etc/tinc/$TINC_NETNAME/tinc-up
                chmod +x /etc/tinc/$TINC_NETNAME/tinc-down

		#Generate Certificate
		tinc -n $TINC_NETNAME generate-keys 2048 < /dev/null
		
		#Add Interface
		ip tuntap add tun1 mode tun
		
		
               
$@
