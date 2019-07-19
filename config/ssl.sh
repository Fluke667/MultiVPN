#!/bin/sh

  echo " ---> Generate External files *.ext"
    echo client > ${CRT_CA_EXT}
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
