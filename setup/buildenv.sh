#!/usr/bin/env bash

# functions used in the scripts
source setup/functions.sh

echo "***"
echo "*** majordomus: installing the build environment"
echo "***"

hide_output wget https://raw.githubusercontent.com/majordomus/gitreceive/master/gitreceive
sudo chmod +x gitreceive
sudo mv gitreceive /usr/local/bin/gitreceive

sudo gitreceive init

sudo mkdir -p $MAJORDOMUS_DATA/git
sudo chmod 777 $MAJORDOMUS_DATA/git
sudo cp conf/receiver /home/git/receiver

# back to the origin
cd $MAJORDOMUS_ROOT