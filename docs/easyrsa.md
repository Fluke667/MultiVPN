Certificates
====

## Easyrsa Build

build by [OPENVPN-Easyrsa](https://github.com/OpenVPN/easy-rsa)



1. Initialize the pki file

```
./easyrsa init-pki

```

2. Create a root certificate

```

./easyrsa build-ca nopass

```

3. Create a server-side certificate and a private key

```
./easyrsa gen-req server nopass

```

4. Sign the server certificate

```
./easyrsa sign server server
```

5. Create Diffie-Hellman

```
./easyrsa gen-dh

```

6. Create a client certificate

```
./easyrsa build-client-full client nopass
```



