#!/bin/sh

echo "**** install+configure pip3 ****"
if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi
rm -r /usr/lib/python*/ensurepip
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
