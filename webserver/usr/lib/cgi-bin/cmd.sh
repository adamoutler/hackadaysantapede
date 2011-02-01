#!/bin/bash
echo "Content-type: text/html"
echo ""
device=`echo "$QUERY_STRING" | sed -n 's/^.*device=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"|sed "s/%2F/\//g"`

command=`echo "$QUERY_STRING" | sed -n 's/^.*command=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`


echo -en "$command\r" >"$device"
cat /var/www/index.html
echo "$command""ing command sent to $device"
