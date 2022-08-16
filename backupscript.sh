#!/bin/bash

#prerequirements
apt install davfs2 -y

MountPoint="/backups"
MountUrl="example.com/backups"

#create random number
RandNum=$(shuf -i 1000000000-9999999999 -n 1)
TempLocation="/TEMP-$RandNum"

PterodactylUserData="/var/lib/pterodactyl"
NginxConfigs="/etc/nginx"
WebsiteContent="/var/www"
SqlUser="root"
SqlPass=""

#mount netwrok drive, for automatic auth look in /etc/davfs2/secrets
mkdir --parents $MountPoint
mount --types davfs $MountUrl $MountPoint
if [ $? -ne 0 ]; then
    echo "failed mounting"
    exit 1
fi

CurrentDate=$(date --utc | sed 's/\ /_/g' | sed 's/\:/_/g')
mkdir --verbose --parents $TempLocation/$CurrentDate
cp --verbose --recursive {$PterodactylUserData,$NginxConfigs,$WebsiteContent} $TempLocation/$CurrentDate

#export mariadb database(s)
mysqldump --user="$SqlUser" --password="$SqlPass" --all-databases > $TempLocation/$CurrentDate/databases.sql

#compress
tar --create --gzip --verbose --file=$TempLocation/$CurrentDate.tar.gz $TempLocation/$CurrentDate
#move zip to network drive
cp --verbose $TempLocation/$CurrentDate.tar.gz $MountPoint
#temp fix for archive not uploading
umount -v $MountPoint && mount --types davfs $MountUrl $MountPoint && umount -v $MountPoint
#remove Temp Location
rm --recursive --force {$TempLocation,$MountPoint}
