#!/bin/bash

# To make this script works properly in he RIL, add the following
# to ~/.ssh/config
#
# Host azure
#     Hostname 10.203.6.248
#     User boonleng
#     Port 2202
# Host woodstock
#     Hostname 10.203.6.248
#     User boonleng
#     Port 2203
# Host burne
#     Hostname 10.203.6.248
#     User root
#     Port 2204

. ${HOME}/boonlib-sh/boonlib.sh

mount_host azure
mount_host burne
mount_host woodstock
