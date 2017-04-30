#!/bin/bash

host1="starbuck.nwc.ou.edu"
host2="-p 20000 localhost"
#host2="-p 20002 localhost"
tunnel1="~/starbuck.tunnel"
tunnel2="~/tiffany.tunnel"

px10k=10.203.7.6
raxpol=10.203.6.141

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

	extra="-L 2203:${px10k}:2202"
	extra="${extra} -L 2204:${px10k}:2204"
	extra="${extra} -L 2205:${px10k}:2205"
	extra="${extra} -L 10002:${px10k}:10000"
	extra="${extra} -L 10080:${px10k}:8001"
	extra="${extra} -L 18080:${px10k}:8080"
	extra="${extra} -L 2206:${raxpol}:2202"
	extra="${extra} -L 2207:${raxpol}:2204"
	extra="${extra} -L 2208:${raxpol}:2205"
	echo -e "\033[38;5;51m${tunnel2}:\033[38;5;225m ${extra}\033[0m"
	ssh -M -S ${tunnel2} -fnNT ${extra} ${host2}
fi

