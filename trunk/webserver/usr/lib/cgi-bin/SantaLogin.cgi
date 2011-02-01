#!/bin/sh
echo "Content-type: text/html"
echo ""
device=`echo "$QUERY_STRING" | sed -n 's/^.*device=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"|sed "s/%2F/\//g"`
echo -en "Santa\rHo\r" >$device
cat /var/www/index.html
