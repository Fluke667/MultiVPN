#!/bin/sh

  echo " ---> Generate External files *.ext"
    echo null > ${CRT_CA_EXT}
    echo basicConstraints = CA:FALSE >> ${CRT_SRV_EXT}
    echo subjectKeyIdentifier=hash >> ${CRT_SRV_EXT}
    echo authorityKeyIdentifier=keyid >> ${CRT_SRV_EXT}
    echo basicConstraints = critical,CA:true >> ${CRT_ISS_EXT}
    echo keyUsage = critical,keyCertSign >> ${CRT_ISS_EXT}
    echo basicConstraints = CA:FALSE >> ${CRT_CLI_EXT}
    echo subjectKeyIdentifier=hash >> ${CRT_CLI_EXT}
    echo authorityKeyIdentifier=keyid >> ${CRT_CLI_EXT}
    echo extendedKeyUsage = serverAuth,clientAuth >> ${CRT_PUB_EXT}
    echo subjectAltName = @alt_names >> ${CRT_PUB_EXT}
    echo [alt_names] >> ${CRT_PUB_EXT}

if [ ! -f "$CRT_CA.crt" ]
        then
        
echo " ---> Generate Root CA private key"
openssl genrsa -out ${CRT_CA}.key ${CRT_KEY_LENGTH} 
echo " ---> Generate Root CA certificate request"
openssl req -new -key ${CRT_CA}.key -out ${CRT_CA}.csr -subj $CRT_CA_SUBJ
echo " ---> Generate self-signed Root CA certificate"
openssl req -x509 -key ${CRT_CA}.key -in ${CRT_CA}.csr -out ${CRT_CA}.crt -days ${CRT_DAYS}
openssl req -x509 -key ${CRT_CA}.key -in ${CRT_CA}.csr -out ${CRT_CA}.pem -days ${CRT_DAYS}


#openssl genrsa -out ${CAname}.key ${CAkeyLength} 
#openssl req -x509 -new -nodes -key ${CAname}.key -sha256 -days ${CAexpire} -out ${CAname}.pem -subj $CAsubject

else
  echo "ENTRYPOINT: $CRT_CA.crt already exists"
fi



if [ ! -f "$CRT_SRV.crt" ]
        then
echo " ---> Generate SRV private key"
	openssl genrsa -out ${CRT_SRV}.key ${CRT_KEY_LENGTH}
echo " ---> Generate SRV certificate request"
	openssl req  -new -key ${CRT_SRV}.key -out ${CRT_SRV}.csr -subj ${CRT_SRV_SUBJ}
echo " ---> Generate SRV certificate"
	openssl x509 -req -extfile ${CRT_SRV_EXT} -in ${CRT_SRV}.csr -CA ${CRT_CA}.pem -CAkey ${CRT_CA}.key \
		     -CAcreateserial -out ${CRT_SRV}.crt -days ${CRT_DAYS} -sha256
		     
else
  echo "ENTRYPOINT: $CRT_SRV.crt already exists"
fi


if [ ! -f "$CRT_CLI.crt" ]
        then
echo " ---> Generate CLI private key"
	openssl genrsa -out ${CRT_CLI}.key ${CRT_KEY_LENGTH}
echo " ---> Generate CLI certificate request"
	openssl req  -new -key ${CRT_CLI}.key -out ${CRT_CLI}.csr -subj ${CRT_CLI_SUBJ}
echo " ---> Generate CLI certificate"
	openssl x509 -req -extfile ${CRT_CLI_EXT} -in ${CRT_CLI}.csr -CA ${CRT_CA}.pem -CAkey ${CRT_CA}.key \
		     -CAcreateserial -out ${CRT_CLI}.crt -days ${CRT_DAYS} -sha256
		     
else
  echo "ENTRYPOINT: $CRT_CLI.crt already exists"
fi


    if [ ! -f "$CRT_PUB.crt" ]
        then
echo " ---> Generate PUB private key"
    openssl genrsa -out ${CRT_PUB}.key ${CRT_KEY_LENGTH}
echo " ---> Generate PUB certificate request"
    openssl req  -new -key ${CRT_PUB}.key -out ${CRT_PUB}.csr -subj ${CRT_PUB_SUBJ}
echo " ---> Generate PUB certificate"
    openssl x509 -req -in ${CRT_PUB}.csr -CA ${CRT_CA}.pem -CAkey ${CRT_CA}.key \
             -CAcreateserial -out ${CRT_PUB}.crt -days ${CRT_DAYS} -sha256
    
else
  echo "ENTRYPOINT: $CRT_PUB.crt already exists"
fi



    if [ ! -f "$STUNNEL_CRT.pem" ]
        then
	
    openssl req -x509 -nodes -newkey rsa:2048 -days 3650 -subj '/CN=stunnel' \
                -keyout $STUNNEL_KEY.key -out $STUNNEL_CRT.pem
    chmod 600 $STUNNEL_CRT.pem
    
    else
  echo "ENTRYPOINT: $STUNNEL_CRT.pem already exists"
fi







    if [ ! -f "$CRT_DIFF.pem" ]
        then
echo " ---> Generate Diffie-Hellman Key"
  openssl dhparam -out "${CRT_DIFF}.pem" "${CRT_DIFF_LENGTH}"

else
  echo "ENTRYPOINT: $CRT_DIFF.pem already exists"
fi



if [ ! -f "$CRT_CA_COMB.pem" ]
then
  # make combined CA and issuer ca-comb.pem
  echo " ---> Generate a combined root and issuer ca.pem"
  cat "$CRT_CLI.crt" "$CRT_CA.crt" > "$CRT_CA_COMB"
else
  echo "ENTRYPOINT: $CRT_CA_COMB.pem already exists"
fi



if [ ! -f "$CRT_KEYSTORE.pfx" ]
then
  # make PKCS12 keystore
  echo " ---> Generate $CRT_KEYSTORE.pfx"
  openssl pkcs12 \
    -export \
    -in "${CRT_PUB}.crt" \
    -inkey "${CRT_PUB}.key" \
    -certfile "${CRT_CA}.pem" \
    -password "pass:${CRT_KEYSTORE_PASS}" \
    -out "${CRT_KEYSTORE}.pfx"
else
  echo "ENTRYPOINT: $CRT_KEYSTORE.pfx already exists"
fi

exec "$@"
