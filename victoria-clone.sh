#!/bin/bash

src_dev="mmcblk0"
dst_dev="sda"

src_base="mmcblk0p"
dst_base="sda"
label="victoria"

# Hyper parameters
debug=false
size1=$((64 * 1024 * 1024 / 512))
total_size=$((1280 * 1024 * 1024 / 512))

# Functions
function log() {
	if [ $# -gt 1 ]; then
		color=${1}
		shift
	else
		color="123"
	fi
	echo -e "\033[38;5;${color}m${@}\033[m"
}

# Check for target disk
chk=$(cat /proc/partitions | grep -m 1 ${dst_dev})
if [ -z "${chk}" ]; then
	log 204 "Could not find the destination device ${dst_dev}."
	exit
fi

sfd0=$(sfdisk -d /dev/${src_dev})

log "Targeted sizes:"
echo "boot = ${size1} ($((size1 / 2048)) MB)   total_size = ${total_size} ($((total_size / 2048)) MB)"
echo ""
log 211 "Source partition scheme:"
echo "${sfd0}"

sfd1=$(echo "${sfd0}" | sed -e "\/dev\/${src_base}2/s/start=[^,]*/start= P2_START/" -e "\/dev\/${src_base}2/s/size=[^,]*/size= P2_SIZE/")

if [ "${debug}" == "true" ]; then
	echo ""
	log 215 "Mutating ..."
	echo "${sfd1}"
	echo ""
fi

sfd1=$(echo "${sfd1}" | sed -e "\/dev\/${src_base}1/s/size=[^,]*/size= ${size1}/")

if [ "${debug}" == "true" ]; then
	echo ""
	echo "${sfd1}"
	echo ""
fi

p1_start=$(echo ${sfd0} | grep -Po "\/dev\/${src_base}1 : start= \K[^ ,]*")
p2_start=$((p1_start + size1))

sfd1=$(echo "${sfd1}" | sed -e "s/P2_START/${p2_start}/")

if [ "${debug}" == "true" ]; then
	echo ""
	echo "${sfd1}"
	echo ""
fi

p2_size=$((total_size - p2_start))
sfd1=$(echo "${sfd1}" | sed -e "s/P2_SIZE/${p2_size}/")
sfd1=$(echo "${sfd1}" | sed -e "s/${src_base}/${dst_base}/g")
sfd1=$(echo "${sfd1}" | sed -e "s/${src_dev}/${dst_dev}/g")

echo ""
log 82 "New partition scheme:"
echo "${sfd1}"

next_sector=$((p2_start + p2_size))
actual_total_size=$((next_sector / 2048))

echo ""
log "Last block = $((next_sector - 1))   Total size = ${actual_total_size} MB"

echo -n "Proceed ? [y/n] "
read resp
resp=$(echo "${resp}" | tr '[:upper:]' '[:lower:]')
if [ "${resp}" != "y" ] && [ "${resp}" != "yes" ]; then
	exit
fi

# ===

echo ""
log "Using dd for the first 4 MB ..."


dd if=/dev/${src_dev} of=/dev/${dst_dev} bs=1M count=4

echo ""
log "Applying new partition scheme ..."

sfdisk --force /dev/${dst_base} > /dev/null <<< "${sfd1}"
sync

yes | mkfs -t vfat -F 32 -n $(echo "${label}" | tr '[:lower:]' '[:upper:]') /dev/${dst_base}1
yes | mkfs -t ext4 -L ${label} /dev/${dst_base}2

sync

log "Synchronizing file systems ... (be patient)"

rsync_options="--force -rltWDEHXAgoptx"

rm -rf /mnt/clone
mkdir -p /mnt/clone

mount "/dev/${dst_base}2" "/mnt/clone"
sleep 1
rsync ${rsync_options} --delete \
	--exclude '.gvfs' \
	--exclude '/dev/*' \
	--exclude '/mnt/clone/*' \
	--exclude '/proc/*' \
	--exclude '/run/*' \
	--exclude '/sys/*' \
	--exclude '/tmp/*' \
	// /mnt/clone
sync

if [ ! -d /mnt/clone/boot ]; then
	log "Creating /mnt/clone/boot ... (usually not necessary)"
	mkdir -p /mnt/clone/boot
fi

mount "/dev/${dst_base}1" "/mnt/clone/boot"
sleep 1
rsync ${rsync_options} --delete \
	--exclude '.gvfs' \
	--exclude 'lost\+found/*' \
	/boot/ /mnt/clone/boot
sync

df -h

cmdline=$(cat /mnt/clone/boot/cmdline.txt)
fstab=$(cat /mnt/clone/etc/fstab)
echo ""
log 211 "Original cmdline.txt"
echo "${cmdline}"
echo ""
log 211 "Original fstab:"
echo "${fstab}"

first_uuid=$(lsblk -n -o PARTUUID /dev/${src_base}1)
if [ -z "${first_uuid}" ]; then
	log 214 "Unable to find partition UUID, assigning one ..."
	disk_id=$(od -A n -t x -N 4 /dev/urandom)
	disk_id=${disk_id:1}
	printf "x\ni\n0x${disk_id}\nr\nw\nq\n" | fdisk "/dev/${dst_dev}"
	sync
	sleep 1
	partprobe "/dev/${dst_dev}"
fi

for p in 1 2; do
	src_uuid=$(lsblk -n -o PARTUUID /dev/${src_base}${p})
	dst_uuid=$(lsblk -n -o PARTUUID /dev/${dst_base}${p})
	if [ "${debug}" == "true" ]; then
		log "p = ${p}   src = ${src_uuid}   dst = ${dst_uuid}"
	fi
	cmdline=$(echo "${cmdline}" | sed -e "s/${src_uuid}/${dst_uuid}/g")
	fstab=$(echo "${fstab}" | sed -e "s/${src_uuid}/${dst_uuid}/g")
done

echo ""
log 82 "New cmdline.txt:"
echo "${cmdline}"
echo ""
log 82 "New fstab"
echo "${fstab}"

echo "${cmdline}" > /mnt/clone/boot/cmdline.txt
echo "${fstab}" > /mnt/clone/etc/fstab

sync

umount /mnt/clone/boot /mnt/clone
