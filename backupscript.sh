#!/bin/bash

#prerequirements
apt install zip -y
apt install davfs2 -y


MountPoint="/backups"
MountUrl="example.com/backups"

TempLocation="/tmp"

PterodactylUserData="/var/lib/pterodactyl"
NginxConfigs="/etc/nginx"
WebsiteContent="/var/www"
SqlUser="root"
SqlPass=""

#mount netwrok drive, for automatic auth look in /etc/davfs2/secrets
mkdir /backups
mount -t davfs $MountUrl $MountPoint

CurrentDate=$(date | sed 's/\ /_/g')
mkdir -p $TempLocation/$CurrentDate
cp -vr {$PterodactylUserData,$NginxConfigs,$WebsiteContent} $TempLocation/$CurrentDate

#export mariadb database(s)
mysqldump --user="$SqlUser" --password="$SqlPass" --all-databases > $TempLocation/$CurrentDate/databases.sql

#compress
zip -r9 $TempLocation/$CurrentDate.zip $TempLocation/$CurrentDate
#move zip to network drive
cp $TempLocation/$CurrentDate.zip $MountPoint
#unmount Mount Point
umount $MountPoint
#remove Temp Location
rm -rf $TempLocation
