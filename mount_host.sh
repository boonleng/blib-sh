#!/bin/bash

# This function respects the SSH login profile in .ssh/config

# If no hostname is supplied, the default is anastasia (main host of PX-10k)
if [ -z ${1} ]; then
	DEST=anastasia
else
	DEST=${1}
fi

if [ ! -z ${BLIB_HOME} ]; then
	. ${BLIB_HOME}/blib.sh
elif [ -d ${HOME}/blib-sh/blib.sh ]; then
	. ${HOME}/blib-sh/blib.sh
elif [ -d ${HOME}/bin/blib.sh ]; then
	. ${HOME}/bin/blib.sh
else
	echo "Unable to find blib-sh"
	exit
fi

mount_host ${DEST}
