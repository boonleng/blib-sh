#!/bin/bash

# Start port number for SSH connections
p=20000

# Start port number for VNC connections
q=55900

# Initialize an empty string
str=""

# Make N pull down from the SSH server
for ((i=0; i<4; i++)); do
	str="$str -L $p:localhost:$p";
	str="$str -L $q:localhost:$q";
	p=$((p+1))
	q=$((q+1))
done

# ARRC webserver
str="$str -L 20004:rwv01.arrc.nor.ou.edu:22"

for ((i=22000; i<22003; i++)); do
	str="$str -L $i:localhost:$i";
done

while read line; do
	if [ $line ]; then
		str="$str -L $p:$line:22";
		p=$((p+1))
	 fi
done < $HOME/bin/hosts.sshfs

echo $str

