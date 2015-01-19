#!/usr/bin/env bash

echo "***"
echo "*** majordomus: installing the build environment"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

if [ ! -L "/usr/local/bin/gitreceive" ]; then
	sudo ln -s $MAJORDOMUS_ROOT/bin/gitreceive /usr/local/bin/gitreceive
fi

if [ ! -d "/home/git" ]; then
	sudo mkdir -p $MAJORDOMUS_DATA/git
	sudo chmod 777 $MAJORDOMUS_DATA/git
	
	sudo gitreceive init
	
	# replace the default script with our receiver script
	sudo rm /home/git/receiver
	sudo ln -s $MAJORDOMUS_ROOT/bin/receiver /home/git/receiver
fi

# back to the origin
cd $MAJORDOMUS_ROOT