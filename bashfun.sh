#!/bin/bash

function synclibrary()
{
	if [ -z "${2}" ]; then
		host="cornflower.local"
	else
		host="${2}"
	fi
	
	# Library to synchronize
	if [ "${1}" == "photos" ]; then
		src="${HOME}/Pictures/Photos\ Library.photoslibrary"
		dst="${host}:~/Pictures/"
	elif [ ${1} == "itunes" ]; then
		src="${HOME}/Music/iTunes"
		dst="${host}:~/Music/"
	fi
	
	# Some basic flags
	flags="-a -v --no-p --no-o --no-g --delete --exclude=${HOME}/.synclibrary"

	# Go / no go from ${1}; set the screen color if we are going for real
	if [[ ${#} -gt 2 && "${3}" == "go" ]]; then
		echo "Going for real ..."
		tput setaf 6
	else
		echo "Simulating ..."
		flags="-n ${flags}"
	fi
	
	# Assemble the command
	comm="rsync ${flags} ${src} ${dst}"
	echo ${comm}
	eval ${comm}

	# Restore the screen color
	tput sgr0
}

function syncitunes()
{
	synclibrary itunes ${1} ${2}
}
function syncphotos()
{
	synclibrary photos ${1} ${2}
}
