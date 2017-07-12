#!/bin/bash

# This function respects the SSH login profile in .ssh/config

# If no hostname is supplied, the default is anastasia (main host of PX-10k)
if [ -z ${1} ]; then
	DEST=anastasia
else
	DEST=$1
fi

if [ -d /Volumes${DEST} ]; then
    diskutil unmountDisk /Volumes/${DESK}
fi

mkdir /Volumes/${DEST}

options="-o auto_cache,reconnect,defer_permissions,negative_vncache,volname=${DEST}"

sshfs ${DEST}:/ /Volumes/${DEST} ${options}

