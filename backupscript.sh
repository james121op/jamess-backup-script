#!/bin/bash

#prerequirements
apt install zip -y

BackupLocation="/backups"

PterodactylUserData="/var/lib/pterodactyl"
NginxConfigs="/etc/nginx"
WebsiteContent="/var/www"
SqlUser="root"
SqlPass="."

CurrentDate=$(date | sed 's/\ /_/g')
mkdir -p $BackupLocation/$CurrentDate
cp -vr {$PterodactylUserData,$NginxConfigs,$WebsiteContent} $BackupLocation/$CurrentDate

#export mariadb database(s)
mysqldump --user="$SqlUser" --password="$SqlPass" --all-databases > $BackupLocation/$CurrentDate/databases.sql

#compress
zip -r9 $BackupLocation/$CurrentDate.zip $BackupLocation/$CurrentDate
#remove uncompressed version
rm -rf $BackupLocation/$CurrentDate
