#!/bin/bash

# HTTP: Turn on a web server serving static files

echo "***"
echo "*** majord: installing nginx"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

# Some Ubuntu images start off with Apache. Remove it since we
# will use nginx. Use autoremove to remove any Apache depenencies.
if [ -f /usr/sbin/apache2 ]; then
	echo "Removing apache..."
	hide_output apt-get -y purge apache2 apache2-*
	hide_output apt-get -y --purge autoremove
fi

# Install nginx, turn off nginx's default website.
apt_install nginx
sudo rm -f /etc/nginx/sites-enabled/default

# Copy in a nginx configuration file for common and best-practices SSL settings from @konklone. 
# Replace STORAGE_ROOT so it can find the DH params.
sudo sed "s#MAJORDOMUS_DATA#$MAJORDOMUS_DATA#" conf/nginx/nginx-ssl.conf > /etc/nginx/nginx-ssl.conf

# Fix some nginx defaults. The server_names_hash_bucket_size seems to prevent long domain names?
conf/editconf.py /etc/nginx/nginx.conf -s server_names_hash_bucket_size="64;"

# Default web location
if [ ! -d $MAJORDOMUS_DATA/www ]; then
	sudo mkdir -p $MAJORDOMUS_DATA/www
fi
sudo rm -f $MAJORDOMUS_DATA/www/default
sudo ln -s $MAJORDOMUS_ROOT/app/public $MAJORDOMUS_DATA/www/default

# move the basic configuration into place
sudo cp $MAJORDOMUS_ROOT/conf/nginx/nginx.conf /etc/nginx/conf.d/local.conf

# Other nginx settings will be configured by the management service
# since it depends on what domains we're serving, which we don't know
# until additional domains have been created.

# Start service
restart_service nginx

# Open ports.
ufw_allow http
ufw_allow https

