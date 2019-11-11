#!/bin/bash

src_dev="mmcblk0"
dst_dev="sda"

src_base="mmcblk0p"
dst_base="sda"
label="victoria"

size1=$((60 * 1024 * 1024 / 512))
total_size=$((1280 * 1024 * 1024 / 512))

sfd0=$(sfdisk -d /dev/${src_dev})

# echo "${sfd0}"

sfd1=$(echo "${sfd0}" | sed -e "\/dev\/${src_base}1/s/size=[^,]*/size= ${size1}/")

# echo "${sfd1}"

p1_start=$(echo ${sfd0} | grep -Po "\/dev\/${src_base}1 : start= \K[^ ,]*")
p2_start_orig=$(echo ${sfd1} | grep -Po "\/dev\/${src_base}2 : start= \K[^ ,]*")
p2_start_new=$((p1_start + size1))
sfd1=$(echo "${sfd1}" | sed -e "s/${p2_start_orig}/${p2_start_new}/")

# echo "${sfd1}"

p2_size_orig=$(echo ${sfd0} | grep -Po "\/dev\/${src_base}2 : start= [0-9]*, size= \K[^ ,]*")
p2_size_new=$((total_size - p2_start_new))
sfd1=$(echo "${sfd1}" | sed -e "s/${p2_size_orig}/${p2_size_new}/")

#sfd1=$(echo "${sfd1}" | sed -e "s/${src_dev}/${dst_dev}/g")

echo "${sfd1}"

total=$((p2_start_new + p2_size_new))
total_size=$((total * 512 / 1024 / 1024))

echo "---"
echo "Last block = $((total - 1))  Total size = ${total_size} MB"

# ===

dd if=/dev/${src_dev} of=/dev/${dst_dev} bs=512K count=8

sfdisk --force /dev/${dst_base} > /dev/null <<< "${sfd1}"

mkfs -t vfat -F 32 /dev/${dst_base}1
mkfs -t ext4 -L ${label} /dev/${dst_base}2

rsync_options="--force -rltWDEHXAgoptx"

rm -rf /mnt/clone

mkdir -p /mnt/clone

mount /dev/${dst_base}2 /mnt/clone

mkdir -p /mnt/clone/boot

mount /dev/${dst_base}1 /mnt/clone/boot

rsync $rsync_options --delete $exclude_useropt --exclude '.gvfs' --exclude '/dev/*' --exclude '/mnt/clone/*' --exclude '/proc/*' --exclude '/run/*' --exclude '/sys/*' --exclude '/tmp/*' // /mnt/clone

rsync $rsync_options --delete $exclude_useropt --exclude '.gvfs' --exclude 'lost\+found/*' /boot/ /mnt/clone/boot

sync
