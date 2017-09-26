#!/bin/bash

name=$1
if [ -z ${name} ]; then
	name="anastasia"
fi

case $name in
	"mediapc" )
		mac="6c:62:6d:08:cc:f9"
		ip="192.168.1.255"
		port="7"
		;;
	"abacus" )
		mac="8c:89:a5:57:ae:af"
		ip="192.168.1.255"
		port="7"
		;;
	"sapphire" )
		mac="00:15:F2:5C:25:0C"
		ip="192.168.1.102"
		port="7"
		;;
	"woodstock" )
		mac="20:cf:30:43:8b:20"
		ip="192.168.3.100"
		port="7"
		;;
	"quorra" )
		mac="20:cf:30:f1:7d:f8"
		ip="10.197.0.23"
		port="7"
		;;
	"rhea" )
		mac="20:cf:30:f1:7c:b2"
		ip="192.168.3.5"
		port="11"
		;;
	"celeste" )
		mac="3c:07:54:56:8c:7f"
		ip="192.168.1.102"
		port="11"
		;;
	"tiffany" )
		mac="00:3e:e1:bf:f4:cd"
		ip="192.168.2.8"
		port="11"
		;;
        "anastasia" )
                mac="0c:c4:7a:34:9a:1c"
		ip="10.203.7.255"
                port="11"
                ;;
	"deepsky" )
		mac="00:0e:c6:88:db:b0"
		ip="192.168.2.255"
		port="11"
		;;
	"dodger" )
		mac="00:e0:4c:a8:16:f8"
		ip="192.168.2.255"
		port="11"
		;;
	"marina" )
		mac="0c:c4:7a:6f:25:ea"
		ip="10.203.7.255"
		port="11"
		;;
        "morning" )
                mac="00:50:b6:d1:8a:ec"
                ip="192.168.2.255"
                port="11"
                ;;
        "dawn" )
                mac="00:50:b6:d1:8a:ec"
                ip="192.168.2.255"
                port="11"
                ;;
        "dawnwifi" )
                mac="00:50:b6:d1:8a:ec"
                ip="10.203.7.255"
                port="11"
                ;;
	* )
		echo "Uknown machine"
		exit
		;;
esac

echo -e "Waking up \033[1;35m${name}\033[0m @ ${mac} @ \033[1;92m${ip}\033[0m:${port} ..."
wol.pl $mac $ip $port

