#!/usr/bin/env bash

echo "***"
echo "*** majordomus: installing the build environment"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

sudo ln -s $MAJORDOMUS_ROOT/bin/gitreceive /usr/local/bin/gitreceive

if [ ! -z "/home/git/receiver"]; then
	sudo gitreceive init
	sudo mkdir -p $MAJORDOMUS_DATA/git
	sudo chmod 777 $MAJORDOMUS_DATA/git
fi

sudo cp conf/receiver /home/git/receiver

# back to the origin
cd $MAJORDOMUS_ROOT