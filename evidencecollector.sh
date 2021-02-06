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
for f in *.vmdk
do
	7z x s3-drive/$f -ooutput/ '[SYSTEM]/*'
done
echo "DONE!!!"
