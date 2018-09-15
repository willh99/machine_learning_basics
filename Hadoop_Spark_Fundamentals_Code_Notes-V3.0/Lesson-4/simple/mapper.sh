#!/bin/bash
while read line ; do
for token in $line; do
if [ "$token" = "Kutuzov" ] ; then
  echo "Kutuzov,1"
elif [ "$token" = "Petersburg" ] ; then
  echo "Petersburg,1"
fi
done
done

