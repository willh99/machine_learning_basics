#!/bin/bash
kcount=0
pcount=0
while read line ; do
if [ "$line" = "Kutuzov,1" ] ; then
 let kcount=kcount+1
elif [ "$line" = "Petersburg,1" ] ; then
 let pcount=pcount+1
fi
done
echo "Kutuzov,$kcount"
echo "Petersburg,$pcount"

