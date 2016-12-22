#!/bin/bash

# This function respects the SSH login profile in .ssh/config

# If no hostname is supplied, the default is anastasia (main host of PX-10k)
if [ -z ${1} ]; then
	DEST=anastasia
else
	DEST=$1
fi

if [ ! -d /Volumes/${DEST} ]; then
	mkdir /Volumes/${DEST}
fi

options="-o auto_cache,reconnect,follow_symlinks,defer_permissions,negative_vncache,volname=${DEST}"

sshfs ${DEST}:/ /Volumes/${DEST} ${options}

