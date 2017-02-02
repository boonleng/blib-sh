#!/bin/bash

if [ -z "${1}" ]; then
	src=/dev/disk1s2
else
	src="${1}"
fi

mkdir -p /Volumes/ntfs
sudo ntfs-3g ${src} /Volumes/ntfs -o ping_diskarb,volname="ntfs"

