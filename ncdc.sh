#!/bin/bash

if [ -z ${1} ]; then
	echo "Supply a link, please."
	exit 0;
fi

order="${1##*has/}"

echo -e "Creating directory \033[1;33m~/Downloads/${order}\033[0m for download ..."
mkdir -p ~/Downloads/${order}
cd ~/Downloads/${order}

# Get the filelist
wget -q -nd -np ${1%/}/fileList.txt

# Go through the filelist to get all the files
if [ ! -f fileList.txt ]; then
	# Do the old school method, get everything in the folder
	wget -r -q -l 2 -nd -np --show-progress --reject index* -A *.gz ${1}
else
	i=1
	n=$(wc -l fileList.txt)
	n=${n% *}
	n=$((n+0))
	while read file; do
		url="${1%/}/${file}"
		if [[ -z ${i} || -z ${n} ]]; then
			n=$(wc -l fileList.txt)
			i=0
		fi
		echo "${i} of ${n} ${url}"
		wget -q --show-progress -nd -np ${1%/}/${file} -O ${file##*/}
		i=$((i+1))
	done < fileList.txt
fi

cd - >/dev/null

