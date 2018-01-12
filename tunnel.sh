#!/bin/bash

host1="starbuck.nwc.ou.edu"
host2="-p 20000 localhost"
#host2="-p 20002 localhost"
tunnel1="~/starbuck.tunnel"
tunnel2="~/tiffany.tunnel"

px10k=10.203.7.6
raxpol=10.203.6.141
px1000=10.203.6.248

resp=$(ssh -S ${tunnel1} -O check ${host1} 2>&1)
if [[ ${resp} == Master* ]]; then
	resp=$(ssh -S ${tunnel2} -O check ${host2} 2>&1)
	if [[ ${resp} == Master* ]]; then
		echo -e "Closing \033[38;5;51m${tunnel2}\033[0m ..."
		ssh -S ${tunnel2} -O exit ${host2}
	fi
	echo -e "Closing \033[38;5;82m${tunnel1}\033[0m ..."
	ssh -S ${tunnel1} -O exit ${host1}
else
	extra=`tconfig.sh`
	extra="${extra} -L 10000:${raxpol}:10000"
	echo "Logging in with tunneling setup ..."
	tput setaf 5
	echo -e "\033[38;5;82m${tunnel1}\033[38;5;225m ${extra}\033[0m"
	ssh -M -S ${tunnel1} -fnNT ${extra} ${host1}

        extra=""
	extra="${extra} -L 2201:${px1000}:2201"   # px1000 / anastasia
	extra="${extra} -L 2202:${px1000}:2202"   # px1000 / burne
	extra="${extra} -L 2203:${px1000}:2203"   # px1000 / azure
	extra="${extra} -L 2204:${px1000}:2204"   # px1000 /
	extra="${extra} -L 2205:${px1000}:2205"   # px1000 / 
	extra="${extra} -L 10080:${px10k}:8001"
	extra="${extra} -L 18080:${px10k}:8080"
	extra="${extra} -L 2206:${raxpol}:2201"   # raxpol / marina
	extra="${extra} -L 2207:${raxpol}:2202"   # raxpol / peyton
	extra="${extra} -L 2208:${raxpol}:2203"   # raxpol / talia
	echo -e "\033[38;5;51m${tunnel2}:\033[38;5;225m ${extra}\033[0m"
	ssh -M -S ${tunnel2} -fnNT ${extra} ${host2}
fi

