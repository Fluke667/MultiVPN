#!/bin/sh

set -eu
mkdir -p /etc/ssh/keys


if [ ! -f "/etc/ssh/keys/ssh_host_rsa_key" ]; then
        if [ -z "$SSH_PRIV_KEY_RSA" ]; then
            # Neuen RSA-Key erzeugen - Achtung, dieser ändert sich mit jedem neuen Container
            ssh-keygen -f /etc/ssh/keys/ssh_host_rsa_key -N '' -t rsa > /dev/null 2>&1
            echo "***** PLEASE SET SSH_PRIV_KEY_RSA VARIABLE TO: *****"
            cat /etc/ssh/keys/ssh_host_rsa_key
            echo "*****************************************************"
        else
            echo "$SSH_PRIV_KEY_RSA" > /etc/ssh/keys/ssh_host_rsa_key
            chown root.root /etc/ssh/keys/ssh_host_rsa_key
            chmod 600 /etc/ssh/keys/ssh_host_rsa_key
        fi
fi

if [ ! -f "/etc/ssh/keys/ssh_host_dsa_key" ]; then
        if [ -z "$SSH_PRIV_KEY_DSA" ]; then
            # Neuen DSA-Key erzeugen - Achtung, dieser ändert sich mit jedem neuen Container
            ssh-keygen -f /etc/ssh/keys/ssh_host_dsa_key -N '' -t dsa > /dev/null 2>&1
            echo "***** PLEASE SET SSH_PRIV_KEY_DSA VARIABLE TO: *****"
            cat /etc/ssh/keys/ssh_host_dsa_key
            echo "*****************************************************"
        else
            echo "$SSH_PRIV_KEY_DSA" > /etc/ssh/keys/ssh_host_dsa_key
            chown root.root /etc/ssh/keys/ssh_host_dsa_key
            chmod 600 /etc/ssh/keys/ssh_host_dsa_key
        fi
fi

if [ ! -f "/etc/ssh/keys/ssh_host_ed25519_key" ]; then
        if [ -z "$SSH_PRIV_KEY_ED25519" ]; then
            # Neuen ED25519-Key erzeugen - Achtung, dieser ändert sich mit jedem neuen Container
            ssh-keygen -f /etc/ssh/keys/ssh_host_ed25519_key -N '' -t ed25519 > /dev/null 2>&1
            echo "***** PLEASE SET SSH_PRIV_KEY_ED25519 VARIABLE TO: *****"
            cat /etc/ssh/keys/ssh_host_ed25519_key
            echo "*********************************************************"
        else
            echo "$SSH_PRIV_KEY_ED25519" > /etc/ssh/keys/ssh_host_ed25519_key
            chown root.root /etc/ssh/keys/ssh_host_ed25519_key
            chmod 600 /etc/ssh/keys/ssh_host_ed25519_key
        fi

fi

if [ ! -f "/etc/ssh/keys/ssh_host_ecdsa_key" ]; then
        if [ -z "$SSH_PRIV_KEY_ECDSA" ]; then
            # Neuen ECDSA-Key erzeugen - Achtung, dieser ändert sich mit jedem neuen Container
            ssh-keygen -f /etc/ssh/keys/ssh_host_ecdsa_key -N '' -t ecdsa > /dev/null 2>&1
            echo "***** PLEASE SET SSH_PRIV_KEY_ECDSA VARIABLE TO: *****"
            cat /etc/ssh/keys/ssh_host_ecdsa_key
            echo "*****************************************************"
        else
            echo "$SSH_PRIV_KEY_ECDSA" > /etc/ssh/keys/ssh_host_ecdsa_key
            chown root.root /etc/ssh/keys/ssh_host_ecdsa_key
            chmod 600 /etc/ssh/keys/ssh_host_ecdsa_key
        fi
fi

mkdir -p /etc/ssh/authorized_keys
# Add Public Keys to root account
if [ -n "$SSH_USERKEYS_ROOT" ]; then
		echo "$SSH_USERKEYS_ROOT" > /etc/ssh/authorized_keys/root
fi

# Create sysop account and add Public Keys to it
if [ -n "$SSH_AUTH_KEYS" ] || [ -n "$USER_KEYS_SYSOP" ]; then
		adduser -g "administration" -D sysop
		passwd -u sysop

		echo "$SSH_AUTH_KEYS" > /etc/ssh/authorized_keys/sysop
		echo "$USER_KEYS_SYSOP" >> /etc/ssh/authorized_keys/sysop
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
	mkdir -p /var/run/sshd
fi

exec "$@"
