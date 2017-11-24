#!/bin/bash

. $HOME/bin/boonlib.sh

LOGFILE=$HOME/log/rtun.log

# Login and External system
USERHOST="cheo4524@starbuck.nwc.ou.edu"

if [[ $HOSTNAME == "cerulean.local" ]]; then
	COMMAND="ssh -f -N -R 20000:localhost:22 -R 55900:localhost:5900 -R 20001:dawn.local:22 -R 55901:dawn.local:5900 -R 20002:tiffany.local:22 -R 55902:tiffany.local:5900 -R 20003:dodger.local:22 -R 55903:dodger.local:5900 $USERHOST >/dev/null 2>&1"
	TEST="ssh $USERHOST netstat -an | egrep "tcp.*:20000.*LISTEN" >/dev/null 2>&1"
elif [[ $HOSTNAME == "celeste.local" ]]; then
	COMMAND="ssh -f -N -R 22000:localhost:22 -R 22001:cerulean.local:22 $USERHOST >/dev/null 2>&1"
	TEST="ssh $USERHOST netstat -an | egrep "tcp.*:22000.*LISTEN" >/dev/null 2>&1"
fi

ps ax | grep -e "${COMMAND:0:20}" | grep -v grep > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	msg="No tunnel found. Respawning ..."
	$COMMAND &
	$TEST
	if [ $? -ne 0 ]; then
		msg="${msg} failed. Try again later."
	else
		msg="${msg} ok."
	fi
else
	$TEST
	if [ $? -ne 0 ] ; then
		msg="Stalled tunnel. Respawning ..."
		pid=$(ps ax | grep -e "${COMMAND:0:20}" | grep -v grep | awk '{ print $1 }')
		sudo kill -9 $pid >/dev/null 2>&1
		$COMMAND &
		$TEST
		if [ $? -ne 0 ]; then
			msg="${msg} failed. Try again later."
		else
			msg="${msg} ok."
		fi
	else
		msg="Tunnel okay."
	fi
fi

log ${msg}

