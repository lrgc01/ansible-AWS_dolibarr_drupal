#!/bin/sh
#FreeDNS updater script

UPDATEURL="http://sync.afraid.org/u/wg5sveMTKQ3EPFYFceGLxwQA/"
DOMAIN="lrgc01.uk.to"

registered=$(nslookup $DOMAIN|tail -n2|grep A|sed s/[^0-9.]//g)

  current=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)
       [ "$current" != "$registered" ] && {                           
          wget -q -O /dev/null $UPDATEURL 
          echo "DNS updated on:"; date
  }
