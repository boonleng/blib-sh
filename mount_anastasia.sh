#!/bin/bash


if [ -z ${1} ]; then
	DEST=anastasia
else
	DEST=$1
fi

if [ ! -d /Volumes/${DEST} ]; then
	mkdir /Volumes/${DEST}
fi

options="-o auto_cache,reconnect,follow_symlinks,defer_permissions,negative_vncache,volname=${DEST}"

sshfs root@${DEST}:/ /Volumes/${DEST} ${options}

