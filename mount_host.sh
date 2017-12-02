#!/bin/bash

# This function respects the SSH login profile in .ssh/config

# If no hostname is supplied, the default is anastasia (main host of PX-10k)
if [ -z ${1} ]; then
	DEST=anastasia
else
	DEST=${1}
fi

. ${HOME}/blib-sh/blib.sh

mount_host ${DEST}

