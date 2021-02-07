#!/bin/bash
read -p "Access key ID:" accesskey
read -p  "Secret access key: " secretkey
read -p "Enter S3 bucket name: " bucketname
read -p "Evidence Folder: " evidencefolder

echo "$accesskey:$secretkey" > ~/.passwd-s3fs

chmod 600 ~/.passwd-s3fs
mkdir s3drive
s3fs $bucketname s3drive

evidencepath="s3drive"
if [ -z "$evidencefolder" ] 
then 
	evidencepath="$evidencepath/$evidencefolder"
fi
echo "$evidencepath"
sudo apt install p7zip-full p7zip-rar

mkdir localoutput
mkdir s3drive/output
for evidencefile in "$evidencepath/*.vmdk"
do
	hostname=$(basename "$evidencefile" .vmdk | sed -e 's/ /_/g')
	echo "EXTRACTING FILES FROM : $hostname"
	cd localoutput
	mkdir $hostname
	cd ..
	7z x "$evidencefile" -olocaloutput/"$hostname" '[SYSTEM]/*' 'Windows/System32/winevt/*' 'Users/*' 'Windows/System32/config' '*/History/*' '*/prefetch/*' '*/appcompat/program/*' '*etl'
	7z a localoutput/$hostname.zip localoutput/$hostname/*
	cp localoutput/$hostname.zip s3drive/output
done
echo "#####  Archive(s) copied to s3 bucket  ########"
