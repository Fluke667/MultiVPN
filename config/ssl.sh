#!/bin/sh

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


	openssl genrsa -out ${CertName}.key ${CertKeyLength}
	openssl req  -new -key ${CertName}.key -out ${CertName}.csr -subj ${CertSubject} 
	openssl x509 -req -extfile ${ConfigFile} -in ${CertName}.csr -CA ${CAname}.pem -CAkey ${CAname}.key \
		     -CAcreateserial -out ${CertName}.crt -days ${CertExpire} -sha256

