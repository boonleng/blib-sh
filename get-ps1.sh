#!/bin/bash

VERBOSE=0

COLORS="
tiffany 51 33 121 226
cornflower 69 33 160 15
rwv01 204
rdv01 154
dcv01 45
dwv05 213
bumblebee 220
"

function get_params() {
	while read -r line; do
		echo "${line}"
	done < <(printf '%s\n' "${COLORS}") | grep ${HOSTNAME%%.*}
}

params=$(get_params)
if [ -z "${params}" ]; then
	echo "Machine ${HOSTNAME} not in the list"
	exit
fi
IFS=" " read name m x y z <<< ${params}
if [ ${VERBOSE} -gt 0 ]; then
	echo "params -> ${name} ${m} ${x} ${y} ${z}"
fi

if [[ -z "${1}" ]]; then
	mm="\[\e[38;5;${m}m\]\h\[\e[m\]:\[\e[38;5;82m\]\w"
	if [[ ${USER} == "root" ]]; then
		uu="\[\e[38;5;15;48;5;160m\] \u \[\e[m\]"
	elif [[ ${USER} == "ldm" ]]; then
		#uu="\[\e[38;5;220m\]\u\[\e[m"
		uu="\[\e[38;5;220;48;5;237m\] \u \[\e[m\]"
	else
		uu="\[\e[38;5;15;48;5;237m\] \u \[\e[m\]"
	fi
	if [[ ! -z ${x} && ! -z ${y} && ! -z ${z} ]]; then
		pp="\[\e[38;5;${x}m\]>\[\e[38;5;${y}m\]>\[\e[38;5;${z}m\]>\[\e[m\]"
	else
		gcc_ver=$(gcc --version | head -n 1)
		if [[ ${gcc_ver} == *"Ubuntu"* ]]; then
			pp="\[\e[38;5;202m\]$\[\e[m\]"
		else
			pp="\[\e[38;5;118m\]$\[\e[m\]"
		fi
	fi
	if [ ${VERBOSE} -gt 0 ]; then
		echo ${mm}
		echo ${uu}
		echo ${pp}
	fi
elif [[ "${1}" == "zsh" ]]; then
	mm="%F{${m}}%m%F{15}:%F{82}%~"
	uu="%F{15}%K{237} %n %k"
	if [[ ! -z ${x} && ! -z ${y} && ! -z ${z} ]]; then
		pp="%F{${x}}>%F{${y}}>%F{${z}}>%f"
	else
		pp="$"
	fi
fi

echo "${mm} ${uu} ${pp} "
