#!/bin/sh

mkdir -p /etc/cloak/

cat > ${CLOAK_SRV_CONF} <<-EOF
{
  "ProxyBook": {
    "shadowsocks": "127.0.0.1:8388",
    "openvpn": "127.0.0.1:8389",
    "tor": "127.0.0.1:9001"
  },
  "RedirAddr": "$CLOAK_WEBSRVADDR",
  "PrivateKey": "$CLOAK_PRIVKEY",
  "AdminUID": "$CLOAK_UID",
  "DatabasePath": "$CLOAK_DB_PATH"
}
EOF


cat > ${CLOAK_CLI_CONF} <<EOF
{
	"ProxyMethod":"shadowsocks",
	"EncryptionMethod":"plain",
	"UID":"5nneblJy6lniPJfr81LuYQ==",
	"PublicKey":"IYoUzkle/T/kriE+Ufdm7AHQtIeGnBWbhhlTbmDpUUI=",
	"ServerName":"www.bing.com",
	"NumConn":4,
	"BrowserSig":"firefox"
}
EOF


"$@"
