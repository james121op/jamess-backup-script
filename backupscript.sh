#!/bin/bash

#prerequirements
apt install zip -y
apt install davfs2 -y


MountPoint="/backups"
MountUrl="example.com/backups"

TempLocation="/TEMP-4124122421352324112424"

PterodactylUserData="/var/lib/pterodactyl"
NginxConfigs="/etc/nginx"
WebsiteContent="/var/www"
SqlUser="root"
SqlPass=""

#mount netwrok drive, for automatic auth look in /etc/davfs2/secrets
mkdir /backups
mount -t davfs $MountUrl $MountPoint

CurrentDate=$(date | sed 's/\ /_/g' | sed 's/\:/_/g')
mkdir -p $TempLocation/$CurrentDate
cp -vr {$PterodactylUserData,$NginxConfigs,$WebsiteContent} $TempLocation/$CurrentDate

#export mariadb database(s)
mysqldump --user="$SqlUser" --password="$SqlPass" --all-databases > $TempLocation/$CurrentDate/databases.sql

#compress
zip -cJvf $TempLocation/$CurrentDate.tar.xz $TempLocation/$CurrentDate
#move zip to network drive
cp $TempLocation/$CurrentDate.tar.xz $MountPoint
#unmount Mount Point
umount $MountPoint
#remove Temp Location
rm -rf $TempLocation
