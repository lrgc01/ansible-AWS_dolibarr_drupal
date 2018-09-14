#!/bin/sh
#FreeDNS updater script
DOM_URL_PAIR="http://sync.afraid.org/u/wg5sveMTKQ3EPFYFceGLxwQA/ lrgc01.uk.to http://sync.afraid.org/u/de7wHJAUyj6dQTPb6wWETYD3/ lrgc01.us.to"

set $DOM_URL_PAIR

while [ "$1" != '' ]
do
UPDATEURL=$1
DOMAIN=$2
shift 2
registered=$(nslookup ${DOMAIN}|tail -n2|grep A|sed s/[^0-9.]//g)

  current=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)
       [ "$current" != "$registered" ] && {                           
          echo wget -q -O /dev/null ${UPDATEURL}
          echo "DNS updated on:"; date
  }
done
