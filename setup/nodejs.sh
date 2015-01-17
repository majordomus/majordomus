#!/usr/bin/env bash

# functions used in the scripts
source setup/functions.sh

echo "***"
echo "*** majordomus: installing languages & stacks: nodejs "
echo "***"

# node.js
cd /tmp
sudo curl -sL https://deb.nodesource.com/setup | sudo bash -
apt_install nodejs

# back to the origin
cd $MAJORDOMUS_ROOT