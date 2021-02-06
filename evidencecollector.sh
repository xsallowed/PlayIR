#!/bin/bash
read -p "Access key ID:" accesskey
read -p  "Secret access key: " secretkey
read -p "Enter S3 bucket name: " bucketname
#read -p "Evidence Folder: " evidencefolder
echo "$accesskey:$secretkey" > ~/.passwd-s3fs

chmod 600 .passwd-s3fs
mkdir s3-drive
s3fs $bucketname ~/s3-drive

sudo apt install p7zip-full p7zip-rar

mkdir output
#if [[-z"$evidencefolder"]] then 
#	cd "$evidencefolder"
#fi
for evidencefile in *.vmdk
do
	mkdir "${evidencefile%.*}"
	7z x s3-drive/$evidencefile -ooutput/"${evidencefile%.*}" '[SYSTEM]/*' 'Windows/System32/winevt/*' 'Users/*' 'Windows/System32/config' '*/History/*' '*/prefetch/*' '*/appcompat/program/*' '*etl'
	7z a output/"${evidencefile%.*}" ./output/"${evidencefile%.*}"/*
	cp "${evidencefile%.*}".7z s3-drive/
done

echo "DONE!!!"
