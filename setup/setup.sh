#!/usr/bin/env bash

# majordomus root location
MAJORDOMUS_ROOT=/opt/majordomus/majord
MAJORDOMUS_DATA=/opt/majordomus/majord-data
MAJORDOMUS_USER=majord

# functions used in the scripts
source setup/functions.sh

# update system packages to make sure we have the latest upstream versions of things from Ubuntu.
echo "***"
echo "*** majordomus: updating ubuntu first"
echo "***"

hide_output apt-get update
hide_output apt-get -y upgrade

# install some basic
apt_install unzip curl sysstat build-essential git

# make sure we are on a defined local
if [ -z `locale -a | grep en_US.utf8` ]; then
    # generate locale if not exists
    hide_output locale-gen en_US.UTF-8
fi

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

if [ -f "/etc/majord.conf" ]; then
	source /etc/majord.conf # load global vars
fi

# Automatic configuration, e.g. as used in our Vagrant configuration.
if [ "$PUBLIC_IP" = "auto" ]; then
	# Use a public API to get our public IP address, or fall back to local network configuration.
	PUBLIC_IP=$(get_publicip_from_web_service 4 || get_default_privateip 4)
fi
if [ "$PUBLIC_IPV6" = "auto" ]; then
	# Use a public API to get our public IPv6 address, or fall back to local network configuration.
	PUBLIC_IPV6=$(get_publicip_from_web_service 6 || get_default_privateip 6)
fi
if [ "$PRIMARY_HOSTNAME" = "auto" ]; then
	# Generate a probably-unique subdomain under our justtesting.email domain.
	PRIMARY_HOSTNAME=`echo $PUBLIC_IP | sha1sum | cut -c1-5`.$DOMAIN_NAME
fi

# Save the global options in /etc/majord.conf so that standalone tools know where to look for data
cat > /etc/majord.conf << EOF;
DOMAIN_NAME=$DOMAIN_NAME
PRIMARY_HOSTNAME=$PRIMARY_HOSTNAME
PUBLIC_IP=$PUBLIC_IP
PUBLIC_IPV6=$PUBLIC_IPV6
PRIVATE_IP=$PRIVATE_IP
PRIVATE_IPV6=$PRIVATE_IPV6
CSR_COUNTRY=$CSR_COUNTRY
EOF

# create a majordomus user next
sudo su -c "useradd $MAJORDOMUS_USER -s /bin/bash -m -g sudo"
sudo chpasswd << 'END'
majord:majord
END

# always install ruby
source setup/ruby.sh

# install additional languages if needed
if [ -z "$DISABLE_DEVTOOLS" ]; then
	source setup/golang.sh
	source setup/nodejs.sh
fi

echo "***"
echo "*** majordomus: installing services"
echo "***"

source setup/system.sh
#source setup/dns.sh
source setup/ssl.sh
source setup/web.sh
source setup/docker.sh
source setup/consul.sh
source setup/buildenv.sh

echo "***"
echo "*** majordomus: cleanup"
echo "***"

sudo apt-get clean
