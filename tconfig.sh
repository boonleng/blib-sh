#!/bin/bash

# Start port number for SSH connections
p=20000

# Start port number for VNC connections
q=55900

# Initialize an empty string
str=""

# Computers in office
for ((i=0; i<4; i++)); do
	str="$str -L $p:localhost:$p";
	str="$str -L $q:localhost:$q";
	p=$((p+1))
	q=$((q+1))
done

# ARRC web, data, etc. servers
str="$str -L 20004:rwv01.arrc.nor.ou.edu:22"
str="$str -L 20005:10.197.14.59:22"
str="$str -L 20006:10.197.14.53:22"

# Computers in PX-1000
#for ((i=22000; i<22003; i++)); do
#	str="$str -L $i:localhost:$i";
#done

while read line; do
	if [ $line ]; then
		str="$str -L $p:$line:22";
		p=$((p+1))
	 fi
done < $HOME/bin/hosts.sshfs

# Celeste
str="$str -L 22000:localhost:22000"

echo $str

