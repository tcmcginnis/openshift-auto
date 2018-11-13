#!/bin/bash
cd `dirname $0`
ls *.tar *.tgz 2>/dev/null | while read f
do
   echo -n "Loading $f..."
   docker load -i $f
done

