#!/bin/bash

#
# install consul - see https://www.consul.io
#

echo "***"
echo "*** majordomus: installing consul"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

cd /tmp
sudo wget -q https://dl.bintray.com/mitchellh/consul/0.4.1_linux_amd64.zip && sudo mv 0.4.1_linux_amd64.zip consul.zip
sudo unzip /tmp/consul.zip && sudo chmod +x /tmp/consul && sudo mv consul /usr/local/bin/consul
sudo rm /tmp/consul.zip

# create the data folder
sudo mkdir -p $MAJORDOMUS_DATA/consul/data
sudo mkdir -p $MAJORDOMUS_DATA/consul/conf

# make sure consul start on boot
sudo cp $MAJORDOMUS_ROOT/conf/consul.conf /etc/init/consul.conf

# launch consul and init the cluster
sudo consul agent -server -bootstrap-expect 1 -data-dir $MAJORDOMUS_DATA/consul/data -config-dir $MAJORDOMUS_DATA/consul/conf &

# back to majordomus root
cd $MAJORDOMUS_ROOT