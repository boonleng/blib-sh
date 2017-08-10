#!/bin/bash

# To make this script works properly in he RIL, add the following
# to your hosts file
#
# 10.203.6.248    azure
# 10.203.6.248    burne
# 10.203.6.248    woodstock

. ${HOME}/boonlib-sh/boonlib.sh

mount_host azure
mount_host burne
mount_host woodstock

