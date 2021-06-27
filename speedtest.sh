#/bin/bash

if command -v speedtest-cli 1>/dev/null 2>&1; then
	str=$(speedtest-cli --json)
else
	echo "==========================================="
	echo "Error. Need speedtest-cli for this to work."
	echo "-------------------------------------------"
	exit 0
fi

# str='{"download": 0, "upload": 639405830.9767123, "ping": 2.212, "server": {"url": "http://okc-speedtest.onenet.net:8080/speedtest/upload.php", "lat": "35.4675", "lon": "-97.5164", "name": "Oklahoma City, OK", "country": "US", "cc": "US", "sponsor": "OneNet", "id": "17751", "host": "okc-speedtest.onenet.net:8080", "d": 28.714107506802062, "latency": 2.212}, "timestamp": "2019-08-05T21:10:23.643961Z", "bytes_sent": 151519232, "bytes_received": 0, "share": null, "client": {"ip": "129.15.133.239", "lat": "35.2144", "lon": "-97.4536", "isp": "University of Oklahoma", "isprating": "3.7", "rating": "0", "ispdlavg": "0", "ispulavg": "0", "loggedin": "0", "country": "US"}}'
# echo ${r}

function getValue() {
	ss=".*\"${1}\": \([0-9a-zA-Z.\"]*\),"	
	value=$(expr "${str}" : "${ss}")
	echo "${value}"
}

function cecho() {
	echo -e "\033[38;5;214m${1}\033[m = \033[38;5;82m${2}${3}\033[m"	
}

function showKeyValue() {
	value=$(getValue ${1})
	cecho "${1}" "${value}" "${2}"
}

showKeyValue "ping" " ms"

download=$(getValue "download")
download_m=$(echo "scale=2; ${download} / 1024 / 1024" | bc)
cecho "download" "${download_m} Mbps"

upload=$(getValue "upload")
upload_m=$(echo "scale=2; ${upload} / 1024 / 1024" | bc)
cecho "upload" "${upload_m} Mbps"
