#!/bin/bash

#
# install docker
#

echo "***"
echo "*** majordomus: installing docker"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

sudo curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo gpasswd -a ${USER} docker

sudo cp $MAJORDOMUS_ROOT/conf/docker /etc/default/docker
restart_service docker
