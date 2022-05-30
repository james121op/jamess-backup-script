#!/bin/bash

#prerequirements
apt install zip

BackupLocation="/backups"

PterodactylUserData="/var/lib/pterodactyl"
NginxConfigs="/etc/nginx"
WebsiteContent="/var/www"
SqlUser="root"
SqlPass=""

CurrentDate=$(date | sed 's/\ /-/g')
mkdir $BackupLocation/$CurrentDate
cp -r {$PterodactylUserData, $NginxConfigs, $WebsiteContent} $BackupLocation/$CurrentDate
cp $PterodactylUserData $BackupLocation/$CurrentDate

#export mariadb database(s)
mysqldump -u "$SqlUser" -p "$SqlPass" --all-databases > $BackupLocation/$CurrentDate/databases.sql

#compress
zip -r9 $CurrentDate.tar.gz $CurrentDate
