#!/bin/bash
#
# rmtag removes metadata of Mac OS files
#
ls -l@ "$@" | grep -e "Zone\|com.*" | sort | uniq | while read tag; do
	tag=${tag%%\ *}
	len=${#tag}
	tag=${tag:0:$((len-1))}
	comm="xattr -d \"$tag\" \"\$@\""
	echo $tag
	eval "$comm >/dev/null 2>&1"
done

xattr -d ":ZONE.IDENTIFIER:\$DATA" "$@" >/dev/null 2>/dev/null
chmod 644 "*.jpg *png *.mov *.mp3 *.mp4 *.avi *.wmv"
#chmod 644 "$@"

