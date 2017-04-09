#!/bin/bash

pid_file=${HOME}/Downloads/starbuck.pid
pid_tiff=${HOME}/Downloads/tiffany.pid
host=starbuck.nwc.ou.edu

px10k=10.203.7.6
raxpol=10.203.6.141

resp=$(ssh -S master-socket -O check ${host} 2>&1)
if [[ ${resp} == Master* ]]; then
	#pid=${resp##*pid=}
	#pid=${pid%)*}
	#echo "Found tunnel running with pid=${pid}"
	resp=$(ssh -S tiffany-socket -O check -p 20002 localhost 2>&1)
	if [[ ${resp} == Master* ]]; then
		ssh -S tiffany-socket -O exit -p 20002 localhost
	fi
	ssh -S master-socket -O exit ${host}
else
	extra=`tconfig.sh`
	echo "Logging in with tunneling setup ..."
	tput setaf 5
	echo "${host} ${extra}"
	ssh -M -S master-socket -fnNT ${extra} cheo4524@starbuck.nwc.ou.edu

	extra="-L 2203:${px10k}:2202"
	extra="${extra} -L 2204:${px10k}:2204"
	extra="${extra} -L 2205:${px10k}:2205"
	extra="${extra} -L 10002:${px10k}:10000"
	extra="${extra} -L 10080:${px10k}:8001"
	extra="${extra} -L 18080:${px10k}:8080"
	extra="${extra} -L 2206:${raxpol}:2202"
	extra="${extra} -L 2207:${raxpol}:2204"
	extra="${extra} -L 2208:${raxpol}:2205"
	extra="${extra} -L 10000:${raxpol}:10000"
	tput setaf 5
	echo "tiffany: ${extra}"
	tput sgr0
	ssh -M -S tiffany-socket -fnNT ${extra} -p 20002 localhost
	echo $! > ${pid_tiff}
fi
