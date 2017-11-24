#!/bin/bash

# The capacity in MB
if [ -z "$1" ]; then
	sizeInMB=512
else
	sizeInMB=$1
fi

# Custom volume name
if [ -z "$2" ]; then
	volume="RAMDisk"
else
	volume="$2"
fi

numSectors=$((2 * 1024 * sizeInMB))
deviceName=`hdid -nomount ram://${numSectors}`
deviceName=${deviceName%% *}

echo -e "Creating \033[1;35m${volume}\033[0m at \033[1;33m${deviceName}\033[0m ..."

diskutil eraseVolume HFS+ ${volume} ${deviceName}
chmod g+w ${volume}

