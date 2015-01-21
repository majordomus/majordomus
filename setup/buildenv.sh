#!/usr/bin/env bash

echo "***"
echo "*** majordomus: installing the build environment"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

# install & config gitreceive

if [ ! -L "/usr/local/bin/gitreceive" ]; then
	sudo ln -s $MAJORDOMUS_ROOT/bin/gitreceive /usr/local/bin/gitreceive
fi

if [ ! -d "/home/git" ]; then
	sudo mkdir -p $MAJORDOMUS_DATA/git
	sudo chmod 777 $MAJORDOMUS_DATA/git
	
	sudo gitreceive init
	sudo gpasswd -a git docker
	
	# replace the default script with our receiver script
	sudo rm /home/git/receiver
	sudo ln -s $MAJORDOMUS_ROOT/bin/receiver /home/git/receiver
fi

# install & build buildstep

#sudo git clone https://github.com/majordomus/buildstep.git --branch master --single-branch $MAJORDOMUS_BASE/buildstep
#cd $MAJORDOMUS_BASE/buildstep && sudo make build
#if [ ! -L "/usr/local/bin/buildstep" ]; then
#	sudo ln -s $MAJORDOMUS_BASE/buildstep/buildstep /usr/local/bin/buildstep
#fi

# back to the origin
cd $MAJORDOMUS_ROOT