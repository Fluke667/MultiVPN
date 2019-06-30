#!/bin/bash

echo "**** install pip ****"
if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi
exec python3 -m ensurepip
exec rm -r /usr/lib/python*/ensurepip
exec pip3 install --no-cache --upgrade pip setuptools wheel
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
