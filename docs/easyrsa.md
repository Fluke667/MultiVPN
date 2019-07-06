Easy-RSA 3 README
============================



This is a quickstart guide to using Easy-RSA version 3. Detailed help on usage

and specific commands can be found by running ./easyrsa -h.  Additional

documentation can be found in the doc/ directory.



If you're upgrading from the Easy-RSA 2.x series, there are Upgrade-Notes

available, also under the doc/ path.



Setup and signing the first request
-----------------------------------



Here is a quick run-though of what needs to happen to start a new PKI and sign

your first entity certificate:



1. Choose a system to act as your CA and create a new PKI and CA:



        ./easyrsa init-pki

        ./easyrsa build-ca



2. On the system that is requesting a certificate, init its own PKI and generate

   a keypair/request. Note that init-pki is used _only_ when this is done on a

   separate system (or at least a separate PKI dir.) This is the recommended

   procedure. If you are not using this recommended procedure, skip the next

   import-req step.



        ./easyrsa init-pki

        ./easyrsa gen-req EntityName



3. Transport the request (.req file) to the CA system and import it. The name

   given here is arbitrary and only used to name the request file.



        ./easyrsa import-req /tmp/path/to/import.req EntityName



4. Sign the request as the correct type. This example uses a client type:



        ./easyrsa sign-req client EntityName



5. Transport the newly signed certificate to the requesting entity. This entity

   may also need the CA cert (ca.crt) unless it had a prior copy.



6. The entity now has its own keypair, signed cert, and the CA.



Signing subsequent requests
---------------------------



Follow steps 2-6 above to generate subsequent keypairs and have the CA return

signed certificates.



