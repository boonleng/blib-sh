#!/bin/bash

UNAME=$(uname)

# The capacity in MB
if [ -z "${1}" ]; then
    sizeInMB=512
else
    sizeInMB="${1}"
fi

# Custom volume name
if [ -z "${2}" ]; then
    volume="RAMDisk"
else
    volume="${2}"
fi

if [ "${UNAME}" == "Darwin" ]; then
    numSectors=$((2 * 1024 * sizeInMB))
    deviceName=`hdid -nomount ram://${numSectors}`
    deviceName=${deviceName%% *}

    echo -e "Creating \033[1;35m${volume}\033[m at \033[1;33m${deviceName}\033[m ..."

    /usr/sbin/diskutil eraseVolume HFS+ ${volume} ${deviceName}
    chmod g+w ${volume}
elif [ "${UNAME}" == "Linux" ]; then
    if [ "${EUID}" -ne 0 ]; then
        echo "Please run as root or through sudo"
        exit
    fi
    if [ $(mount | grep /mnt/ramdisk | wc -l) -gt 0 ]; then
        echo "RAM disk already exists"
        exit
    fi
    echo "RAM disk can be made permanent with Linux by adding the following to /etc/fstab:"
    echo ""
    echo -e "tmpfs\t/mnt/ramdisk\ttmpfs\tnodev,nosuid,noexec,nodiratime,size=${sizeInMB}M\t0 0"
    echo ""
    if [ ! -d /mnt/ramdisk ]; then
        mkdir -p /mnt/ramdisk
    fi
    echo "Creating /mnt/ramdisk ..."
    eval "mount -t tmpfs -o size=${sizeInMB}m tmpfs /mnt/ramdisk"
fi
