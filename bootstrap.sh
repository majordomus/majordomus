#!/usr/bin/env bash

export MAJORDOMUS_REPO='https://github.com/majordomus/majordomus.dev.git'
export MAJORDOMUS_BRANCH=master
export MAJORDOMUS_ROOT=/opt/majordomus/majord

# clone the repository if it doesn't exist or update otherwise
if [ ! -d $MAJORDOMUS_ROOT ]; then
	
	echo "***"
	echo "*** majordomus: installing git first . . ."
	echo "***"
	
	sudo apt-get -y install git
	
	echo "***"
	echo "*** majordomus: pulling the codebase from repo . . ."
	echo "***"
	
	git clone $MAJORDOMUS_REPO --branch $MAJORDOMUS_BRANCH --single-branch $MAJORDOMUS_ROOT
	
else 
	
	echo "***"
	echo "*** majordomus: updating the codebase . . ."
	echo "***"
	
	cd $MAJORDOMUS_ROOT
	git pull origin $MAJORDOMUS_BRANCH
	
fi

chmod +x $MAJORDOMUS_ROOT/*.sh
chmod +x $MAJORDOMUS_ROOT/setup/*.sh

# start the setup
cd $MAJORDOMUS_ROOT && setup/setup.sh