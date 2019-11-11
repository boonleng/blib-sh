#!/bin/bash

src_dev="mmcblk0"
dst_dev="sda"

size1=$((100 * 1024 * 1024 / 512))
size2=$((1280 * 1024 * 1024 / 512 - size1))

sfd0=$(sfdisk -d /dev/${src_dev})

echo ${sfd0}

sfd1=$(echo ${sfd0} | sed -e "\/dev\/${src_dev}p1/s/size=[^,]*/size= ${size1}/")

p1_start=$(echo ${sfd0} | grep -Po "\/dev\/${src_dev}p1 : start= \K[^ ,]*")

p2_start_orig=$(echo ${sfd1} | grep -Po "\/dev\/${src_dev}p2 : start= \K[^ ,]*")
p2_start_new=$((p1_start + size1))
sfd1=$(echo ${sfd1} | sed -e "s/${p2_start_orig}/${p2_start_new}/")

echo "${sfd1}"

p2_size=$(echo ${sfd0} | grep -Po "\/dev\/${src_dev}p2 : start= [0-9]*, size= \K[^ ,]*")
sfd1=$(echo ${sfd1} | sed -e "s/${p2_size}/${size2}/")

#sfd1=$(echo ${sfd1} | sed -e "s/${src_dev}/${dst_dev}/g")
echo "${sfd1}"
