#!/bin/bash

if [ -z ${1} ]; then
	echo "Supply a link, please."
	exit 0;
fi

order="${1##*has/}"

echo -e "Creating directory \033[1;33m~/Downloads/${order}\033[0m for download ..."
mkdir -p ~/Downloads/${order}
cd ~/Downloads/${order}

wget -r -q -l 2 -nd -np --reject index* -A *.gz ${1}

cd - >/dev/null

