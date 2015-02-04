#!/bin/bash

#
# Install MariaDB as a container.
# 
# 	Parameters:
#		$1	name of container
#		$2	root password for DB
#

echo "***"
echo "*** majordomus: install MariaDB as a container"
echo "***"

source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

docker pull tutum/mariadb

apt_install mariadb-client-5.5 libmariadbd-dev
hide_output sudo apt-get -y autoremove

sudo mkdir -p $MAJORDOMUS_DATA/volumes/$1/v1
sudo mkdir -p $MAJORDOMUS_DATA/volumes/$1/v2
sudo chown -R majord:majord $MAJORDOMUS_DATA/volumes/$1
sudo chmod -R 775 $MAJORDOMUS_DATA/volumes/$1

sudo addgroup messagebus majord

docker create --name $1 -v $MAJORDOMUS_DATA/volumes/$1/v1:/var/lib/mysql -p 3306:3306 -e MARIADB_PASS="$2" tutum/mariadb