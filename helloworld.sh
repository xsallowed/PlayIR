#!/bin/bash

read -p "Evidence Folder: " evidencefolder

evidencepath="s3drive"
if ["$evidencefolder"!=""] 
then 
	 evidencepath="$evidencepath"/"$evidencefolder"
fi

for evidencefile in "$evidencepath"/*.vmdk
do
  hostname=$(sudo basename "$evidencefile" .vmdk)
  echo "evidence path : $evidencepath"
  echo "host : $hostname"
  echo "Evidence file : $evidencefile"	
done

