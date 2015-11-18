#!/bin/bash

if [ -z ${1} ]; then
	echo "Supply a link, please."
	exit 0;
fi

wget -r -l 1 -nd -np --reject index* -A *.gz ${1}

