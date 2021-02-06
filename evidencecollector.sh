#!/bin/bash
read -p "Access key ID:" accesskey
read -p  "Secret access key: " secretkey
read -p "Enter S3 bucket name: " bucketname
read -p "Evidence Folder: " evidencefolder

echo "$accesskey:$secretkey" > .passwd-s3fs
chmod 600 .passwd-s3fs
mkdir s3-drive
s3fs $bucketname s3-drive

evidencepath = "s3-drive"
if [[-z"$evidencefolder"]] then 
	 evidencepath = ${evidencepath}/${evidencefolder}
fi

sudo apt install p7zip-full p7zip-rar

mkdir output

for evidencefile in ${evidencepath}/*.vmdk
do
	hostname = basename ${evidencefile} .vmdk
	mkdir $hostname
	7z x $evidencepath/${evidencefile} -ooutput/${hostname} '[SYSTEM]/*' 'Windows/System32/winevt/*' 'Users/*' 'Windows/System32/config' '*/History/*' '*/prefetch/*' '*/appcompat/program/*' '*etl'
	7z a output/"${evidencefile%.*}".zip ./output/"${evidencefile%.*}"/*
	cp "output/${evidencefile%.*}".7z s3-drive/
done

echo "DONE!!!"
