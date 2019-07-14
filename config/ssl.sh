#!/bin/sh

if [ ! -f "$CRT_CERT_DIR/$CRT_CA_NAME.crt" ]
then
  # generate root certificate

  echo " ---> Generate Root CA private key"
  openssl genrsa \
    -out "$CRT_CERT_DIR/$CRT_CA_NAME.key" \
    "$CRT_KEY_LENGTH"

  echo " ---> Generate Root CA certificate request"
  openssl req \
    -new \
    -key "$CRT_CERT_DIR/$CRT_CA_NAME.key" \
    -out "$CRT_CERT_DIR/$CRT_CA_NAME.csr" \
    -subj "$CRT_CA_SUBJ"

  echo " ---> Generate self-signed Root CA certificate"
  openssl req \
    -x509 \
    -key "$CRT_CERT_DIR/$CRT_CA_NAME.key" \
    -in "$CRT_CERT_DIR/$CRT_CA_NAME.csr" \
    -out "$CRT_CERT_DIR/$CRT_CA_NAME.crt" \
    -days "$CRT_DAYS"
    
  echo " ---> Convert $CRT_CA_NAME.crt into $CRT_CA_NAME.pem Format"
  openssl \
     -x509 \
     -inform DER \
     -outform PEM \
     -in "$CRT_CERT_DIR/$CRT_CA_NAME.crt" \
     -out "$CRT_CERT_DIR/$CRT_CA_NAME.pem"
  
else
  echo "ENTRYPOINT: $CRT_CA_NAME.crt already exists"
fi

if [ ! -f "$CRT_CERT_DIR/$CRT_ISSUER_NAME.crt" ]
then
  # generate issuer certificate

  echo " ---> Generate Issuer private key"
  openssl genrsa \
    -out "$CRT_CERT_DIR/$CRT_ISSUER_NAME.key" \
    "$CRT_KEY_LENGTH"

  echo " ---> Generate Issuer certificate request"
  openssl req \
    -new \
    -key "$CRT_CERT_DIR/$CRT_ISSUER_NAME.key" \
    -out "$CRT_CERT_DIR/$CRT_ISSUER_NAME.csr" \
    -subj "$CRT_ISSUER_SUBJ"

  echo " ---> Generate Issuer certificate"
  openssl x509 \
    -req \
    -in "$CRT_CERT_DIR/$CRT_ISSUER_NAME.csr" \
    -CA "$CRT_CERT_DIR/$CRT_CA_NAME.crt" \
    -CAkey "$CRT_CERT_DIR/$CRT_CA_NAME.key" \
    -out "$CRT_CERT_DIR/$CRT_ISSUER_NAME.crt" \
    -CAcreateserial \
    -extfile "$CRT_ISSUER_EXT" \
    -days "$CRT_DAYS"
    
  echo " ---> Generate Diffie-Hellman Key"
  openssl dhparam \
    -out "$CRT_CERT_DIR/$CRT_DIFF_NAME-$CRT_DIFF_LENGTH.dh" $CRT_DIFF_LENGTH
  # New Command:
  #openssl genpkey -genparam -algorithm DH \
  #  -out "$CRT_CERT_DIR/dhp4096.pem -pkeyopt dh_paramgen_prime_len:" $CRT_DIFF_LENGTH
    
else
  echo "ENTRYPOINT: $CRT_ISSUER_NAME.crt already exists"
fi

if [ ! -f "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.key" ]
then
  # generate public rsa key
  echo " ---> Generate private key"
  openssl genrsa \
    -out "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.key" \
    "$CRT_KEY_LENGTH"
else
  echo "ENTRYPOINT: $CRT_PUBLIC_NAME.key already exists"
fi

if [ ! -f "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.crt" ]
then
  # generate public certificate
  echo " ---> Generate public certificate request"
  openssl req \
    -new \
    -key "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.key" \
    -out "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.csr" \
    -subj "$CRT_PUB_SUBJ"

  # append public cn to subject alt names
  echo "DNS.1 = $CRT_PUBLIC_CN" >> "$CRT_PUBLIC_EXT"

  echo " ---> Generate public certificate signed by $CRT_ISSUER_CN"
  openssl x509 \
    -req \
    -in "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.csr" \
    -CA "$CRT_CERT_DIR/$CRT_ISSUER_NAME.crt" \
    -CAkey "$CRT_CERT_DIR/$CRT_ISSUER_NAME.key" \
    -out "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.crt" \
    -CAcreateserial \
    -extfile "$CRT_PUBLIC_EXT" \
    -days "$CRT_DAYS"
else
  echo "ENTRYPOINT: $CRT_PUBLIC_NAME.crt already exists"
fi

if [ ! -f "$CRT_CERT_DIR/ca.pem" ]
then
  # make combined root and issuer ca.pem
  echo " ---> Generate a combined root and issuer ca.pem"
  cat "$CRT_CERT_DIR/$CRT_ISSUER_NAME.crt" "$CRT_CERT_DIR/$CRT_CA_NAME.crt" > "$CRT_CERT_DIR/ca.pem"
else
  echo "ENTRYPOINT: ca.pem already exists"
fi

if [ ! -f "$CRT_CERT_DIR/$CRT_KEYSTORE_NAME.pfx" ]
then
  # make PKCS12 keystore
  echo " ---> Generate $CRT_KEYSTORE_NAME.pfx"
  openssl pkcs12 \
    -export \
    -in "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.crt" \
    -inkey "$CRT_CERT_DIR/$CRT_PUBLIC_NAME.key" \
    -certfile "$CRT_CERT_DIR/ca.pem" \
    -password "pass:$CRT_KEYSTORE_PASS" \
    -out "$CRT_CERT_DIR/$CRT_KEYSTORE_NAME.pfx"
else
  echo "ENTRYPOINT: $CRT_KEYSTORE_NAME.pfx already exists"
fi

# run command passed to docker run
exec "$@"
