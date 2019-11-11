#!/bin/bash

src_dev="mmcblk0"
dst_dev="sda"

src_base="mmcblk0p"
dst_base="sda"
label="victoria"

# Hyper parameters
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

echo -e "\033[38;5;82m\nNew partition scheme\033[m"
echo "${sfd1}"

total=$((p2_start_new + p2_size_new))
total_size=$((total * 512 / 1024 / 1024))

echo "---"
echo "Last block = $((total - 1))  Total size = ${total_size} MB"

# ===

function log() {
	echo -e "\033[38;5;123m${@}\033[m"
}

echo
log "Using dd the first 4 MB ..."

dd if=/dev/${src_dev} of=/dev/${dst_dev} bs=1M count=4

echo
log "Applying new parition scheme ..."

sfdisk --force /dev/${dst_base} > /dev/null <<< "${sfd1}"

sync

sleep 1

partprobe /dev/${dst_dev}

sleep 1

yes | mkfs -t vfat -F 32 /dev/${dst_base}1
yes | mkfs -t ext4 -L ${label} /dev/${dst_base}2

echo
log "Synchronizing file systems ..."

rsync_options="--force -rltWDEHXAgoptx"

rm -rf /mnt/clone

mkdir -p /mnt/clone

mount /dev/${dst_base}2 /mnt/clone

rsync ${rsync_options} --delete --exclude '.gvfs' --exclude '/dev/*' --exclude '/mnt/clone/*' --exclude '/proc/*' --exclude '/run/*' --exclude '/sys/*' --exclude '/tmp/*' // /mnt/clone

if [ ! -d /mnt/clone/boot ]; then
	log "Creating /mnt/clone/boot ... (usually not necessary)"
	mkdir -p /mnt/clone/boot
fi

mount /dev/${dst_base}1 /mnt/clone/boot

rsync ${rsync_options} --delete --exclude '.gvfs' --exclude 'lost\+found/*' /boot/ /mnt/clone/boot

sync

df -h

cmdline=$(cat /mnt/clone/boot/cmdline.txt)
echo -e "\n\033[38;5;211mOriginal cmdline\033[m"
echo "${cmdline}"

fstab=$(cat /mnt/clone/etc/fstab)
echo -e "\n\033[38;5;211mOriginal fstab\033[m"
echo "${fstab}"

for p in 1 2; do
	src_uuid=$(lsblk -n -o PARTUUID /dev/${src_base}${p})
	dst_uuid=$(lsblk -n -o PARTUUID /dev/${dst_base}${p})
	#echo "src = ${src_uuid}   dst = ${dst_uuid}"
	cmdline=$(echo "${cmdline}" | sed -e "s/${src_uuid}/${dst_uuid}/g")
	fstab=$(echo "${fstab}" | sed -e "s/${src_uuid}/${dst_uuid}/g")
done

echo -e "\n\033[38;5;82mNew cmdline\033[m"
echo "${cmdline}"
echo "${cmdline}" > /mnt/clone/boot/cmdline.txt

echo -e "\n\033[38;5;82mNew fstab\033[m"
echo "${fstab}"
echo "${fstab}" > /mnt/clone/etc/fstab

sync

umount /mnt/clone/boot /mnt/clone
